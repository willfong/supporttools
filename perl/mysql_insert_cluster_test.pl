#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use POSIX;

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 2) {
  my $fn = __FILE__;
  print "\nUsage: $fn <ip of host> <number of inserts> \n";
  exit;
}

my $mysql_server_ip = $ARGV[0];
my $num_of_inserts = $ARGV[1];

my $range = 3;
my $minimum = 7;

my $conn = DBI->connect("dbi:mysql:dbname=test;host=$mysql_server_ip", "root", "pass");

#print "Preparing table...\n";

#my $query = $conn->prepare( "CREATE TABLE inserttest ( id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, fname VARCHAR(50) NOT NULL DEFAULT '', lname VARCHAR(50) NOT NULL DEFAULT '', email VARCHAR(50) NOT NULL DEFAULT '', UNIQUE email_unq ( email ), INDEX name_idx (fname,lname) )" );
#$query->execute();

#$query = $conn->prepare( "CREATE TABLE inserttest_attrib( id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, user_id INT UNSIGNED NOT NULL DEFAULT 0, attrib_1 VARCHAR(50) NOT NULL DEFAULT '', attrib_2 VARCHAR(50) NOT NULL DEFAULT '', INDEX attrib1_idx (attrib_1), INDEX attrib2_idx (attrib_2) )" );
#$query->execute();


print "Inserting Data…\n";

my $query1 = $conn->prepare( "INSERT INTO inserttest ( fname, lname, email ) VALUES ( ?, ?, ? )" );
my $query2 = $conn->prepare( "INSERT INTO inserttest_attrib ( user_id, attrib_1, attrib_2 ) VALUES ( ?, ?, ? )" );

foreach( 1..$num_of_inserts ){

  my $fname = generate_random_string( int( rand($range) ) + $minimum ); 
  my $lname = generate_random_string( int( rand($range) ) + $minimum );
  my $email = generate_random_string( int( rand($range) ) + $minimum ) . '@' . generate_random_string( int( rand($range) ) + $minimum ) . '.com';
  my $attrib1 = generate_random_string( int( rand($range) ) + $minimum );
  my $attrib2 = generate_random_string( int( rand($range) ) + $minimum );

  #tsprint( "$fname\t\t$lname\t\t$email" );
 
  $query1->execute( $fname, $lname, $email );
  my $user_id = $query1->{ q{mysql_insertid}};
  $query2->execute( $user_id, $attrib1, $attrib2 );

  if ( int(rand(10)) > 5 ){

    $attrib1 = generate_random_string( int( rand($range) ) + $minimum );
    $attrib2 = generate_random_string( int( rand($range) ) + $minimum );

    #tsprint( "Adding Extra: $attrib1\t\t$attrib2" );

    $query2->execute( $user_id, $attrib1, $attrib2 );

    if ( int(rand(10)) > 8 ){

      $attrib1 = generate_random_string( int( rand($range) ) + $minimum );
      $attrib2 = generate_random_string( int( rand($range) ) + $minimum );

      #tsprint( "Adding Even More Extra: $attrib1\t\t$attrib2" );

      $query2->execute( $user_id, $attrib1, $attrib2 );

    }


  } 


#  sleep( int( rand(10) + 1 ) );
}


sub generate_random_string {
  # http://th.atguy.com/mycode/generate_random_string/
  my $length_of_randomstring=shift;# the length of 
       # the random string to generate

  my @chars=('a'..'z');
  my $random_string;
  foreach (1..$length_of_randomstring) 
  {
    # rand @chars will generate a random 
    # number between 0 and scalar @chars
    $random_string.=$chars[rand @chars];
  }
  return $random_string;
}

sub tsprint {
  my $time = strftime('%Y-%m-%d %H:%M:%S', localtime());
  my $log = $_[0];
  print "[$time] $log\n";
}

