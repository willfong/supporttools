import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

public class WaitTimeout
{
  public static void main(String[] args)
    throws InterruptedException {

    System.out.println("Hello, Database!");

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
      conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:4306/test?user=w");
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

      System.out.println("Set wait timeout for 10 seconds...");
      rs = stmt.executeQuery("SET SESSION wait_timeout=10");

      System.out.println("First select...");
      rs = stmt.executeQuery("SELECT COUNT(*) FROM mysql.user");

      System.out.println("Sleep for 20 seconds...");
      Thread.sleep(20000);

      System.out.println("Second select...");
      rs = stmt.executeQuery("SELECT COUNT(*) FROM mysql.user");

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

