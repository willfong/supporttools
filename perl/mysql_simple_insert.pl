#!/usr/bin/perl

use strict;
use warnings;

use DBI;
use POSIX;
use Time::HiRes qw(time);

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 1) {
  my $fn = __FILE__;
  print "\nUsage: $fn <host> \n";
  exit;
}
my $host_ip = $ARGV[0];

my $number_of_connections = 200;
my $number_of_transactions = 1000000;

my $bigint = 18446744073709551614;
my $int = 4294967294;
my $ints = 2147483647;
my $tinyint = 254;


=SQL Statement
CREATE TABLE test.`fcc_cards` (
`id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
`b` int(10) unsigned NOT NULL DEFAULT '0',
`c` tinyint(3) unsigned NOT NULL DEFAULT '0',
`d` int(10) unsigned NOT NULL DEFAULT '0',
`e` bigint(20) unsigned NOT NULL, -- userid
`f` tinyint(3) unsigned NOT NULL, -- Decktype
`g` int(11) NOT NULL,
`h` tinyint(3) unsigned NOT NULL DEFAULT '0', -- State
`i` int(10) unsigned NOT NULL,
`j` tinyint(3) unsigned NOT NULL DEFAULT '80',
`k` tinyint(3) unsigned NOT NULL DEFAULT '99',
`l` int(10) unsigned NOT NULL DEFAULT '0',
`m` int(10) unsigned NOT NULL DEFAULT '0',
`n` int(10) unsigned NOT NULL DEFAULT '0',
`o` int(10) unsigned NOT NULL DEFAULT '0',
`p` int(10) unsigned NOT NULL DEFAULT '0',
`q` int(10) unsigned NOT NULL DEFAULT '0',
`r` int(10) unsigned NOT NULL DEFAULT '0',
`s` int(10) unsigned NOT NULL DEFAULT '0',
`t` int(10) unsigned NOT NULL DEFAULT '0',
`u` int(10) unsigned NOT NULL DEFAULT '0',
`v` tinyint(3) unsigned NOT NULL DEFAULT '0',
`w` tinyint(3) unsigned NOT NULL DEFAULT '0',
`x` tinyint(3) unsigned NOT NULL DEFAULT '1',
`y` tinyint(3) unsigned NOT NULL DEFAULT '1',
`z` int(10) unsigned NOT NULL DEFAULT '0',
`a` int(10) unsigned NOT NULL DEFAULT '0',
PRIMARY KEY (`id`),
UNIQUE KEY `cardid` (`e`, `id`),
KEY `userid_decktype_state` (`e`,`f`,`h`)
) ENGINE=InnoDB;
=cut
my $counter = 0;

foreach( 1..$number_of_connections ){
  $counter++;
  my $conn = DBI->connect("dbi:mysql:dbname=test;host=$host_ip;port=3306", "will", "will");

  my $start = time;

  foreach( 1..$number_of_transactions ){
    my $query = $conn->prepare( "INSERT INTO fcc_cards
    ( b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r, s, t, u, v, w, x, y, z, a ) VALUES
    ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ? )" );
    $query->execute(
        int( rand($int) ), #B
        int( rand($tinyint) ), #C
        int( rand($int) ), #D
        int( rand($bigint) ), #E
        int( rand($tinyint)), #F
        int( rand($ints) ), #G
        int( rand($tinyint) ), #H
        int( rand($int) ), #I
        int( rand($tinyint) ), #J
        int( rand($tinyint) ), #K
        int( rand($int) ), #L
        int( rand($int) ), #M
        int( rand($int) ), #N
        int( rand($int) ), #O
        int( rand($int) ), #P
        int( rand($int) ), #Q
        int( rand($int) ), #R
        int( rand($int) ), #S
        int( rand($int) ), #T
        int( rand($int) ), #U
        int( rand($tinyint) ), #V
        int( rand($tinyint) ), #W
        int( rand($tinyint) ), #X
        int( rand($tinyint) ), #Y
        int( rand($int) ), #Z
        int( rand($int) ) #A
      );
  }

  my $end = time;

  my $total = $end - $start;
  my $qps = $number_of_transactions / $total;

  print "$qps\n"

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
