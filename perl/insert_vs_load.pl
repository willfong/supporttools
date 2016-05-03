#!/usr/bin/perl

use strict;
use warnings;
use DBI;
use POSIX;
use POSIX qw( strftime );


my $resultsfile = 'results-'. strftime("%Y%m%d%H%M%S", localtime(time)) . '.txt';
my $temptable = 'insertvsload';
my $tempfile = '/tmp/insertvsload_safe_to_delete.txt';


# Check input params
my $fn = __FILE__;
my $usage = <<EOF;


Usage: $fn <host_ip> <host_user> <host_password> <host_db> <iterations> <batch_size> <insert_size>


Recommendations:
  Batch size:  2000000
  Insert size: 200000

EOF

my $num_args = $#ARGV + 1;
if ($num_args != 7) {
  print $usage;
  exit;
}
my $hostip = $ARGV[0];
my $hostuser = $ARGV[1];
my $hostpass = $ARGV[2];
my $hostdb = $ARGV[3];
my $iterations = $ARGV[4];
my $batchsize = $ARGV[5];
my $insertsize = $ARGV[6];


# Size Check
if ($batchsize > 2400000) {
  print $usage;
  print "\nBatch sizes greater than 2.4M creates a file over 1GB.\nThe MySQL client protocol limits packets to 1GB.\n\n";
  exit;
}
if ($insertsize > 350000) {
  print $usage;
  print "\nInsert size needs to be less than 350000.\n\n";
  exit;
}

# Todo
# check disk space for temp file
# check disk space for data dir
# check max_allowed_packet
# check innodb log file size for rotation


printlog("The INSERT vs LOAD DATA INFILE Challenge!");


printlog("Connecting to the database and preparing things...");
my $conn = DBI->connect("dbi:mysql:mysql_local_infile=1;dbname=$hostdb;host=$hostip;port=3306", "$hostuser", "$hostpass");
$conn->do("DROP TABLE IF EXISTS ".$temptable."_single");
$conn->do("DROP TABLE IF EXISTS ".$temptable."_multi");
$conn->do("DROP TABLE IF EXISTS ".$temptable."_ldi");
$conn->do("CREATE TABLE ".$temptable."_single ( id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, a INT UNSIGNED, b INT UNSIGNED, c VARCHAR(200), d VARCHAR(200), INDEX (b), INDEX (c,d) )");
$conn->do("CREATE TABLE ".$temptable."_multi ( id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, a INT UNSIGNED, b INT UNSIGNED, c VARCHAR(200), d VARCHAR(200), INDEX (b), INDEX (c,d) )");
$conn->do("CREATE TABLE ".$temptable."_ldi ( id INT UNSIGNED PRIMARY KEY AUTO_INCREMENT, a INT UNSIGNED, b INT UNSIGNED, c VARCHAR(200), d VARCHAR(200), INDEX (b), INDEX (c,d) )");
my $pq = $conn->prepare( "INSERT INTO ".$temptable."_single ( a, b, c, d ) VALUES ( ?, ?, ?, ? )" );


# Let's start!
printlog("Logging results to: $resultsfile");
open(my $rf, '>', $resultsfile);
select((select($rf), $|=1)[0]); # Perl blackmagic for turning off write buffering
my $completecmd = join " ", $0, @ARGV;
my $completerows = $iterations * $batchsize;
print $rf <<EOF;
# ------------------------------------------------------------------------
# INSERT vs LOAD DATA INFILE Benchmark Results
# ------------------------------------------------------------------------
# Benchmark executed with:
#   $completecmd
#
# Test Criteria:
#   Total rows inserted:    $completerows
#   Iterations:             $iterations
#   Rows inserted per test: $batchsize
#   Multi-Row INSERT size:  $insertsize
#
# ------------------------------------------------------------------------
# Column 1: Number of rows inserted
# Column 2: Single-Row INSERT load time in seconds
# Column 3: Single-Row INSERT rows per second
# Column 4: Multi-Row INSERT load time in seconds
# Column 5: Multi-Row INSERT rows per second
# Column 6: LOAD DATA INFILE load time in seconds
# Column 7: LOAD DATA INFILE rows per second
# ------------------------------------------------------------------------
EOF


for (my $x = 1; $x <= $iterations; $x++){

  printlog("Iteration: " . $x);
  my $totalrows = $batchsize * ($x - 1);
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
  if ($total_single < 1) {
    $total_single = 1;
  }
  my $qps_single = sprintf("%.1f", $batchsize / $total_single);
  printlog("\tCompleted $batchsize in $total_single seconds ($qps_single rows per second)");


  printlog("\tStarting Multi-Row INSERT benchmark...");
  $start = time;
  open($fh, '<', $tempfile);
  my $query_prefix = "INSERT INTO ".$temptable."_multi (a,b,c,d) VALUES ";
  my $values = '';
  my $counter = 0;
  $conn->do("BEGIN");
  while(my $line = <$fh>) {
    chomp $line;
    my ($a, $b, $c, $d) = split(/(?<!,)\t/, $line);
    $values .= "($a,$b,'$c','$d'),";
    $counter++;
    if ($counter == $insertsize) {
      chop $values;
      my $q = $query_prefix . $values;
      my $insertlength = length($q);
      printlog("\t\tInserting $insertsize rows / $insertlength bytes...");
      $conn->do($q);
      $counter = 0;
      $values = '';
    }
  }
  if ($counter > 0) {
    chop $values;
    my $q = $query_prefix . $values;
    my $insertlength = length($q);
    printlog("\t\tInserting $counter rows / $insertlength bytes...");
    $conn->do($q);
  }
  $conn->do("COMMIT");
  $end = time;
  my $total_multi = $end - $start;
  if ($total_multi < 1) {
    $total_multi = 1;
  }
  my $qps_multi = sprintf("%.1f", $batchsize / $total_multi);
  printlog("\tCompleted $batchsize in $total_multi seconds ($qps_multi rows per second)");


  printlog("\tStarting LOAD DATA INFILE benchmark...");
  $start = time;
  $conn->do("LOAD DATA LOCAL INFILE '$tempfile' INTO TABLE ".$temptable."_ldi ( a, b, c, d )");
  $end = time;
  my $total_ldi = $end - $start;
  if ($total_ldi < 1) {
    $total_ldi = 1;
  }
  my $qps_ldi = sprintf("%.1f", $batchsize / $total_ldi);
  printlog("\tCompleted $batchsize in $total_ldi seconds ($qps_ldi rows per second)");

  print $rf $batchsize*$x . ",$total_single,$qps_single,$total_multi,$qps_multi,$total_ldi,$qps_ldi\n";
}

printlog("Cleaning up...");
unlink $tempfile;
$conn->do("DROP TABLE IF EXISTS ".$temptable."_single");
$conn->do("DROP TABLE IF EXISTS ".$temptable."_multi");
$conn->do("DROP TABLE IF EXISTS ".$temptable."_ldi");
printlog("All done. Thanks for playing!");

sub printlog {
  my $logline=shift;
  my $ts = strftime("%Y-%m-%d %H:%M:%S", localtime(time));
  print "[$ts] $logline\n";
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
