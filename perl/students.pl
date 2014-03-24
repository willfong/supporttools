#!/usr/bin/perl

use strict;
use warnings;

use POSIX;


# =============================================================================
# Tune these

my $number_of_schools = 4;
my $number_of_classes = 50;
my $maximum_number_of_students_per_class = 5000;
my $class_size_deviation_as_percentage = 50;
my $maximum_number_of_classes_per_student = 5;
my $number_of_tests = 16;
my $number_of_questions_per_test = 50;
my $number_of_answers_per_test = 5;


my $csv_school = 'school.csv';
my $csv_classes = 'classes.csv';
my $csv_students = 'students.csv';
my $csv_tests = 'tests.csv';
my $csv_answers = 'answers.csv';

# =============================================================================
# SQL Setup

my $coltype_schoolid = find_int_type( $number_of_schools );
my $coltype_classid = find_int_type( $number_of_classes );
my $coltype_student = find_int_type( $maximum_number_of_students_per_class * $number_of_classes * $number_of_schools );
my $coltype_tests = find_int_type( $number_of_tests );
my $coltype_questions = find_int_type( $number_of_questions_per_test);


print "Preparing table...\n";

#my $query = $conn->prepare( "CREATE TABLE inserttest ( id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, fname VARCHAR(50) NOT NULL DEFAULT '', lname VARCHAR(50) NOT NULL DEFAULT '', email VARCHAR(50) NOT NULL DEFAULT '', UNIQUE email_unq ( email ), INDEX name_idx (fname,lname) )" );
#$query->execute();

#$query = $conn->prepare( "CREATE TABLE inserttest_attrib( id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, user_id INT UNSIGNED NOT NULL DEFAULT 0, attrib_1 VARCHAR(50) NOT NULL DEFAULT '', attrib_2 VARCHAR(50) NOT NULL DEFAULT '', INDEX attrib1_idx (attrib_1), INDEX attrib2_idx (attrib_2) )" );
#$query->execute();


print "Inserting Data…\n";

my $query1 = $conn->prepare( "INSERT INTO inserttest ( fname, lname, email ) VALUES ( ?, ?, ? )" );
my $query2 = $conn->prepare( "INSERT INTO inserttest_attrib ( user_id, attrib_1, attrib_2 ) VALUES ( ?, ?, ? )" );

foreach( 1..$num_of_inserts ){

  my $fname = generate_random_string( int( rand($range) ) + $minimum ); 
  my $lname = generate_random_string( int( rand($range) ) + $minimum );
  my $email = generate_random_string( int( rand($range) ) + $minimum ) . '@' . generate_random_string( int( rand($range) ) + $minimum ) . '.com';
  my $attrib1 = generate_random_string( int( rand($range) ) + $minimum );
  my $attrib2 = generate_random_string( int( rand($range) ) + $minimum );

  tsprint( "$fname\t\t$lname\t\t$email" );
 
  $query1->execute( $fname, $lname, $email );
  my $user_id = $query1->{ q{mysql_insertid}};
  $query2->execute( $user_id, $attrib1, $attrib2 );

  if ( int(rand(10)) > 5 ){

    $attrib1 = generate_random_string( int( rand($range) ) + $minimum );
    $attrib2 = generate_random_string( int( rand($range) ) + $minimum );

    tsprint( "Adding Extra: $attrib1\t\t$attrib2" );

    $query2->execute( $user_id, $attrib1, $attrib2 );

    if ( int(rand(10)) > 8 ){

      $attrib1 = generate_random_string( int( rand($range) ) + $minimum );
      $attrib2 = generate_random_string( int( rand($range) ) + $minimum );

      tsprint( "Adding Even More Extra: $attrib1\t\t$attrib2" );

      $query2->execute( $user_id, $attrib1, $attrib2 );

    }


  } 


#  sleep( int( rand(10) + 1 ) );
}

sub find_int_type
{
  my $num = shift;

  if ($num <= 255)
  {
    return 'TINYINT UNSIGNED';
  }

  if ($num <= 65535)
  {
    return 'SMALLINT UNSIGNED';
  }

  if ($num <= 16777215)
  {
    return 'MEDIUMINT UNSIGNED';
  }

  if ($num <= 4294967295)
  {
    return 'INT UNSIGNED';
  }

  return 'BIGINT UNSIGNED';

}

sub generate_random_string 
{
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

sub tsprint 
{
  my $time = strftime('%Y-%m-%d %H:%M:%S', localtime());
  my $log = $_[0];
  print "[$time] $log\n";
}

