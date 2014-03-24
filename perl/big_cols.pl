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

foreach( 1..$num_of_rcpt ){

  my $val1 = int( rand(1000000) );
  my $val2 = int( rand(1000000) );
  my $val3 = int( rand(1000000) );
  my $val4 = int( rand(1000000) );                                     
  my $val5 = generate_random_string( int( rand(95) ) + 5 );
  my $value = "$val1\t$val2\t$val3\t$val4\t$val5\n";

  print( $value );

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


