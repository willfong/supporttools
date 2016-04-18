import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.PreparedStatement;

public class HelloDb
{ 
  public static void main(String[] args)
  { 

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

    PreparedStatement stmt = null;
    ResultSet rs = null;
    try {

      conn.setAutoCommit(false);
      System.out.println("Preparing statement...");
      stmt = conn.prepareStatement("INSERT INTO foo ( j, i ) VALUES ( ?, ? )");

      for (int j=0;j<1000;j++) {
        System.out.println("Transaction: " + j);
        for (int i=0;i<10000;i++) {
          stmt.setInt(1, j);
          stmt.setInt(2, i);
          stmt.executeUpdate();
        }

        conn.commit();
      }
      System.out.println("All done!");

    // Now do something with the ResultSet ....
    }
    catch (SQLException ex){
        // handle any errors
        System.out.println("SQLException: " + ex.getMessage());
        System.out.println("SQLState: " + ex.getSQLState());
        System.out.println("VendorError: " + ex.getErrorCode());
    }
  }
}

