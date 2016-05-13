import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

import java.sql.Timestamp;
import java.util.Date;

public class Failover
{
  public static void main(String[] args)
    throws InterruptedException {

    System.out.println("Failover Test");

    try {
      System.out.println("Loading driver...");
      Class.forName("org.mariadb.jdbc.Driver");
      //Class.forName("com.mysql.jdbc.Driver");
    } catch (Exception ex) {
      System.out.println("[ERROR] Error with driver: \n" + ex.getMessage());
    }

    Connection conn = null;

    try {
      System.out.println("Connecting to database...");
      conn = DriverManager.getConnection("jdbc:mariadb:replication://127.0.0.1:3307,127.0.0.1:3308,127.0.0.1:3309/test?user=w");
      //conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:4306/test?user=w");
    } catch (SQLException ex) {
      System.out.println("Error connecting to database...");
      // handle any errors
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }

    Statement stmt = null;
    ResultSet rs = null;

    try {

      System.out.println("Starting queries...");

      stmt = conn.createStatement();
      stmt.execute("SELECT 1");
      conn.setReadOnly(true);
      stmt.execute("SELECT 2");

      System.out.println("Sleeping for 30 seconds...");
      Thread.sleep(30000);
   
      System.out.println("Starting queries...");

      stmt = conn.createStatement();
      stmt.execute("SELECT 1");
      conn.setReadOnly(true);
      stmt.execute("SELECT 2");

      System.out.println("All done!");

    }
    catch (SQLException ex){
        // handle any errors
        System.out.println("SQLException: " + ex.getMessage());
        System.out.println("SQLState: " + ex.getSQLState());
        System.out.println("VendorError: " + ex.getErrorCode());
    }
    
  }
}

