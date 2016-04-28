#!/usr/bin/perl

my $resultsfile = 'results.txt';
my $temptable = 'insertvsload';
my $tempfile = '/tmp/insertvsload_safe_to_delete.txt';

# ----------------------------------------------------------------------------

use strict;
use warnings;

use DBI;
use POSIX;
#use Time::HiRes qw(time);
#use POSIX qw( strftime );

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 7) {
  my $fn = __FILE__;
  print "\nUsage: $fn <host_ip> <host_user> <host_password> <host_db> <iterations> <batch_size> <insert_size>\n";
  exit;
}
my $hostip = $ARGV[0];
my $hostuser = $ARGV[1];
my $hostpass = $ARGV[2];
my $hostdb = $ARGV[3];
my $iterations = $ARGV[4];
my $batchsize = $ARGV[5];
my $insertsize = $ARGV[6];


printlog("The INSERT vs LOAD DATA INFILE Challenge!");
printlog("Logging results to: $resultsfile");
open(my $rf, '>', $resultsfile);
print $rf "rows,single,multi,ldi\n";


printlog("Connecting to the database...");
my $conn = DBI->connect("dbi:mysql:mysql_local_infile=1;dbname=$hostdb;host=$hostip;port=3306", "$hostuser", "$hostpass");
$conn->do("DROP TABLE IF EXISTS $temptable");
$conn->do("CREATE TABLE $temptable ( id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, a INT UNSIGNED, b INT UNSIGNED, c VARCHAR(200), d VARCHAR(200), INDEX (b), INDEX (c,d) )");
my $pq = $conn->prepare( "INSERT INTO $temptable ( a, b, c, d ) VALUES ( ?, ?, ?, ? )" );


for (my $x = 0; $x < $iterations; $x++){

  my $totalrows = $batchsize * $x;
  printlog("Iteration: " . ($x+1));
  printlog("\tCurrent row count: $totalrows");


  printlog("\tGenerating data file...");
  open(my $fh, '>', $tempfile);
  foreach( 1..$batchsize ){
    my $a = int(rand(4294967295));
    my $b = int(rand(4294967295));
    my $c = generate_random_string(200);
    my $d = generate_random_string(200);
    print $fh "$a\t$b\t$c\t$d\n";
  }
  close $fh;


  printlog("\tStarting Single INSERT benchmark...");
  my $start = time;
  open($fh, '<', $tempfile);
  $conn->do("BEGIN");
  while(my $line = <$fh>) {
    chomp $line;
    my ($a, $b, $c, $d) = split(/(?<!,)\t/, $line);
    $pq->execute($a, $b, $c, $d);
  }
  $conn->do("COMMIT");
  my $end = time;
  my $total_single = $end - $start;
  my $qps = sprintf("%.1f", $batchsize / $total_single);
  printlog("\tCompleted $batchsize in $total_single seconds ($qps rows per second)");


  printlog("\tStarting Multi-Row INSERT benchmark...");
  $start = time;
  open($fh, '<', $tempfile);
  my $query_prefix = "INSERT INTO $temptable ( a, b, c, d ) VALUES ";
  my $values = '';
  my $counter = 0;
  $conn->do("BEGIN");
  while(my $line = <$fh>) {
    chomp $line;
    my ($a, $b, $c, $d) = split(/(?<!,)\t/, $line);
    $values .= "($a, $b, '$c', '$d'),";
    $counter++;
    if ($counter == $insertsize) {
      my $insertlength = length($values);
      printlog("\t\tInserting $insertsize rows / $insertlength bytes...");
      chop $values;
      $conn->do($query_prefix . $values);
      $counter = 0;
      $values = '';
    }
  }
  if ($x > 0) {
    printlog("\t\tInserting $counter rows...");
    chop $values;
    $conn->do($query_prefix . $values);
  }
  $conn->do("COMMIT");
  $end = time;
  my $total_multi = $end - $start;
  $qps = sprintf("%.1f", $batchsize / $total_multi);
  printlog("\tCompleted $batchsize in $total_multi seconds ($qps rows per second)");


  printlog("\tStarting LOAD DATA INFILE benchmark...");
  $start = time;
  $conn->do("LOAD DATA LOCAL INFILE '$tempfile' INTO TABLE $temptable ( a, b, c, d )");
  $end = time;
  my $total_ldi = $end - $start;
  $qps = sprintf("%.1f", $batchsize / $total_ldi);
  printlog("\tCompleted $batchsize in $total_ldi seconds ($qps rows per second)");

  print $rf $batchsize*$x . ",$total_single,$total_multi,$total_ldi\n";
}


printlog("All done. Thanks for playing!");

sub printlog {
  my $logline=shift;
  my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
  $year += 1900;
  $mon += 1;
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
