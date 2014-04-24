#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use POSIX;

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 2) {
  my $fn = __FILE__;
  print "\nUsage: $fn <counter> <transactions> \n";
  exit;
}
my $count = $ARGV[0];
my $transactions = $ARGV[1];


=SQL Statement
CREATE TABLE perftest (
id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT,
counter INT UNSIGNED,
a INT UNSIGNED,
b INT UNSIGNED,
c INT UNSIGNED
) ENGINE=InnoDB;
=cut
my $counter = 0;

foreach( 1..$count ){
  $counter++;
  my $conn = DBI->connect("dbi:mysql:dbname=test;host=127.0.0.1;port=33001", "root", "");


  my $query = $conn->prepare( "
    INSERT INTO perftest 
      ( counter, a, b, c ) 
    VALUES 
      ( ?, ?, ?, ? ),
      ( ?, ?, ?, ? ),
      ( ?, ?, ?, ? ),
      ( ?, ?, ?, ? ),
      ( ?, ?, ?, ? ),
      ( ?, ?, ?, ? ),
      ( ?, ?, ?, ? ),
      ( ?, ?, ?, ? ),
      ( ?, ?, ?, ? ),
      ( ?, ?, ?, ? )
    " );

  foreach( 1..$transactions ){
    $query->execute(
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        $counter,
        int( rand(100)+1 ),
        int( rand(100)+1 ),
        int( rand(100)+1 )
      );
  }

  print "$counter\n"

}
