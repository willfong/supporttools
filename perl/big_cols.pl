use strict;
use warnings;

# Check input params
my $num_args = $#ARGV + 1;
if ($num_args != 1) {
  my $fn = __FILE__;
  print "\nUsage: $fn <number_of_lines> \n";
  exit;
}

my $num_of_rcpt = $ARGV[0];

print STDERR "\n\nGeneral Usage:\n\n";
print STDERR "CREATE TABLE `sbtest1` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `k` int(10) unsigned NOT NULL DEFAULT '0',
  `c` char(120) NOT NULL DEFAULT '',
  `pad` char(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `k_1` (`k`)
);\n\n";
print STDERR "LOAD DATA INFILE '/tmp/1.txt' INTO TABLE sbtest1 ( k, c, pad );\n\n";
print STDERR "Note: 1 million rows (1000000) is around 250MB.\n\n";

foreach( 1..$num_of_rcpt ){
  print "0\t00000000000-00000000000-00000000000-00000000000-00000000000-00000000000-00000000000-00000000000-00000000000-00000000000\t00000000000-00000000000-00000000000-00000000000-00000000000\n";
}
