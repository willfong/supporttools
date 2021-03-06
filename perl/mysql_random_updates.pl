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
my $query = $conn->prepare( "UPDATE mytable SET f = ? WHERE a = ?" );

my $max_int = 4000000000;
my $old_max_int_counter = 10000;

foreach( 1..$num_of_updates ){

  # Grab the max ID value every 10k updates.
  if( $old_max_int_counter == 10000 ){
    $old_max_int_counter = 0;
    my $query_maxint = $conn->prepare( "SELECT MAX(a) FROM mytable");
    $query_maxint->execute();
    my $ref = $query_maxint->fetchrow_arrayref;
    $max_int = $$ref[0];
  } else {
    $old_max_int_counter++;
  }

  my $a = int( rand( $max_int ) );
  my $f = generate_random_string(int(rand(30))+1);
 
  $query->execute( $f, $a );
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