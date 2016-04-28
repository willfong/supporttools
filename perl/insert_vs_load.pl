#!/usr/bin/perl

my $logfile = 'results.txt';
my 


# ----------------------------------------------------------------------------

use strict;
use warnings;

use DBI;
use POSIX;
#use Time::HiRes qw(time);
#use POSIX qw( strftime );

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 6) {
  my $fn = __FILE__;
  print "\nUsage: $fn <batch_size> <iterations> <host_ip> <host_user> <host_password> <host_db> \n";
  exit;
}
my $batchsize = $ARGV[0];
my $iterations = $ARGV[1];
my $hostip = $ARGV[2];
my $hostuser = $ARGV[3];
my $hostpass = $ARGV[4];
my $hostdb = $ARGV[5];

my $conn = DBI->connect("dbi:mysql:dbname=$hostdb;host=$hostip;port=3306", "$hostuser", "$hostpass");


$conn->do("DROP TABLE IF EXISTS insertvsload");
$conn->do("CREATE TABLE insertvsload ( id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, a INT UNSIGNED, b INT UNSIGNED, c VARCHAR(200), d VARCHAR(200), INDEX (b), INDEX (c,d) )");


for (my $x = 1; $x <= $iterations; $x++){

  printlog("Iteration: $x");

  printlog("Generating data file...");
  open(my $fh, '>', '/tmp/insertvsload.csv');
  foreach( 1..$batchsize ){
    my $a = int(rand(4294967295));
    my $b = int(rand(4294967295));
    my $c = generate_random_string(200);
    my $d = generate_random_string(200);
    print $fh "$a\t$b\t$c\t$d\n";
  }
  close $fh;

    


}


print "done\n";


my $query = $conn->prepare( "INSERT INTO clients ( fname, lname, signed, nodeid ) VALUES ( ?, ?, ?, 1 )" );





print "Done\n";


sub printlog {
  my $logline=shift;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime;
  print "[$year-$mon-$mday $hour:$min:$sec] $logline\n";
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

