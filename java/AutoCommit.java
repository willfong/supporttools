import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

public class AutoCommit
{ 
  public static void main(String[] args)
  { 

    System.out.println("AutoCommit Check");

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
      conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/test?user=root");
      //conn = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/test?user=root");
    } catch (SQLException ex) {
      System.out.println("Error connecting to database...");
      // handle any errors
      System.out.println("SQLException: " + ex.getMessage());
      System.out.println("SQLState: " + ex.getSQLState());
      System.out.println("VendorError: " + ex.getErrorCode());
    }

    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {

      System.out.println("Current AutoCommit Setting: " + conn.getAutoCommit() );
      System.out.println("Setting AutoCommit to: " + !conn.getAutoCommit() );
      conn.setAutoCommit(!conn.getAutoCommit());
      System.out.println("Current AutoCommit Setting: " + conn.getAutoCommit() );
    }
    catch (SQLException ex){
        // handle any errors
        System.out.println("SQLException: " + ex.getMessage());
        System.out.println("SQLState: " + ex.getSQLState());
        System.out.println("VendorError: " + ex.getErrorCode());
    }
  }
}

