#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use POSIX;
use Time::HiRes qw(time);
use POSIX qw( strftime );

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 1) {
  my $fn = __FILE__;
  print "\nUsage: $fn <inserts> \n";
  exit;
}
my $inserts = $ARGV[0];

my $bigint = 18446744073709551614;
my $int = 4294967294;
my $ints = 2147483647;
my $tinyint = 254;

my $conn = DBI->connect("dbi:mysql:dbname=test;host=localhsot;port=3306", "root", "");

my $query = $conn->prepare( "INSERT INTO clients ( fname, lname, signed ) VALUES ( ?, ?, ? )" );

foreach( 1..$inserts ){
    $query->execute(
        generate_random_string(5),
        generate_random_string(5),
        generate_random_date()
      );
}

print "Done\n";


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

sub generate_random_date {
  my $seconds_in_year = 31536000;
  my $timestamp = int(rand($seconds_in_year * 2)) + 1356969600;
  return strftime("%Y-%m-%d", localtime($timestamp));
}
