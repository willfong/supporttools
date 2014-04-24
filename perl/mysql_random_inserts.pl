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
my $query = $conn->prepare( "INSERT INTO mytable ( b, c, d, e, f, g, h, i ) VALUES (?,?,?,?,?,?,?,?)" );

foreach( 1..$num_of_updates ){
 
  $query->execute( 
    int( rand(4000000) ),
    int( rand(4000000) ),
    int( rand(4000000) ),
    int( rand(4000000) ),
    generate_random_string( int( rand(95) ) + 5 ),
    generate_random_string( int( rand(95) ) + 5 ),
    generate_random_string( int( rand(95) ) + 5 ),
    generate_random_string( int( rand(95) ) + 5 )
    );
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