import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

import java.sql.Timestamp;
import java.util.Date;

public class WaitTimeout
{
  public static void main(String[] args)
    throws InterruptedException {

    if (args.length == 2) {
      int waitTimeout;
      int sleepTime;
      try {
        waitTimeout = Integer.parseInt(args[0]);
        sleepTime = Integer.parseInt(args[1]);
      } catch (NumberFormatException e) {
        System.err.println("Must specify numeric values.");
        System.exit(1);
      }
    } else {
      System.err.println("Must specify waitTimeout and sleepTime integers");
      System.exit(1);
    }

    System.out.println("Java WaitTimeout Test");

    try {
      System.out.println("Loading driver...");
      //Class.forName("org.mariadb.jdbc.Driver");
      Class.forName("com.mysql.jdbc.Driver");
    } catch (Exception ex) {
      System.out.println("[ERROR] Error with driver: \n" + ex.getMessage());
    }

    Connection conn = null;

    try {
      System.out.println("Connecting to database...");
      //conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:4306/test?user=w");
      conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:4306/test?user=w");
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

      System.out.println("Set wait timeout for " + args[0] + " seconds...");
      rs = stmt.executeQuery("SET SESSION wait_timeout=" + args[0]);


      String ts;

      for (int i=0; i<10; i++) {
        java.util.Date date= new java.util.Date();
	ts = new Timestamp(date.getTime()).toString();
        System.out.println("[" + ts + "] Running query: " + i);
        rs = stmt.executeQuery("SELECT COUNT(*) FROM mysql.user");
        System.out.println("Sleep for " + args[1] + " seconds...");
        Thread.sleep(Integer.parseInt(args[1])*1000);
      }

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

