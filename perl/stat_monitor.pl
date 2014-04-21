#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use POSIX;
use Time::HiRes qw(time);
use POSIX qw( strftime );

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 2) {
  my $fn = __FILE__;
  print "\nUsage: $fn <status variable> <interval in seconds> \n";
  exit;
}
my $statusvar = $ARGV[0];
my $interval = $ARGV[1];

my $conn = DBI->connect("dbi:mysql:host=localhost;port=3306", "root", "");

my $query = $conn->prepare( "SHOW GLOBAL STATUS LIKE '$statusvar'" );

$query->execute();
my $ref = $query->fetchrow_arrayref;
my $oldvalue = $$ref[1];
my $newvalue = 0;

while(1){

  sleep( $interval );

  $query->execute();
  $ref = $query->fetchrow_arrayref;
  $newvalue = $$ref[1];

  my $diff = sprintf( "%.2f", ( $newvalue - $oldvalue ) / $interval );

  print "$diff\n";

  $oldvalue = $newvalue;

}
