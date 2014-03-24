#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use POSIX;

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 1) {
  my $fn = __FILE__;
  print "\nUsage: $fn <number of updates> \n";
  exit;
}

my $num_of_updates = $ARGV[0];


my $conn = DBI->connect("dbi:mysql:dbname=test", "root");


my $a = int( rand( 100000 ) );
my $b = int( rand( 100000 ) );

my $query = $conn->prepare( "UPDATE foo SET b = ? WHERE a = ?" );


foreach( 1..$num_of_updates ){


  my $a = int( rand( 100000 ) );
  my $b = int( rand( 100000 ) );
 
  $query->execute( $b, $a );


#  sleep( int( rand(10) + 1 ) );
}


sub tsprint {
  my $time = strftime('%Y-%m-%d %H:%M:%S', localtime());
  my $log = $_[0];
  print "[$time] $log\n";
}

