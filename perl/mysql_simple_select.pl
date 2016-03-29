#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use POSIX;
use POSIX qw( strftime );

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 1) {
  my $fn = __FILE__;
  print "\nUsage: $fn <iterations> \n";
  exit;
}
my $iter = $ARGV[0];

my $conn = DBI->connect("dbi:mysql:dbname=test;host=127.0.0.1;port=3306", "root", "");

my $query = $conn->prepare( "SELECT COUNT(*) FROM mysql.user" );

foreach( 1..$iter ){
    $query->execute();
}

print "Done\n";

