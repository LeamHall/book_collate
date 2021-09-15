#!/usr/bin/env perl

# name:     book_collate.pl
# version:  0.0.1
# date:     20210709
# author:   Leam Hall
# desc:     Sample code for using Book::Collate

# Test command
# Run in a directory containing the text files.
#
# perl -I<path to lib> <path to>/book_collate.pl 

# Notes:
#   Requires YAML::Tiny.


use strict;
use warnings;

use Getopt::Long;
use YAML::Tiny;
use Carp;
use lib 'lib';
use Book::Collate;


# subroutines 
sub file_name_from_title {
  (my $file_name)     = @_;
  $file_name          =~ s/[\W]/ /gxm;
  $file_name          = lc($file_name);
  $file_name          =~ s/\s*$//xm;
  $file_name          =~ s/\s+/_/gxm;
  return $file_name;
}

sub show_help {
  print "Usage: $0 \n";
  print "\t --book_dir <dir>       \n";
  print "\t --config_file <file>   \n";
  print "\t --help               This menu \n";
  exit;
}

### Config precedence, highest to lowest:
##  1. Command Line Options
##  2. Config file variables
##  3. Defaults

## Set up defaults
my %configs  = (
  book_dir          => '.',
  output_dir        => 'book',
  report            => 1,
  report_dir        => 'reports',
  section_dir       => 'sections',
  title             => "",
  custom_word_file  => 'data/custom_words.txt',
  weak_word_file    => '',
);

## Set up for GetOptions
my $book_dir;
my $report_dir;
my $config_file = 'book_config.yml';
my $help;

GetOptions(
  "book_dir=s"    => \$book_dir,
  "config_file=s" => \$config_file,
  "help"          => \$help,
);

show_help() if $help;

# Parse the config file, if there is one.
my %file_configs;
if ( -f $config_file ) {
  eval {
    %file_configs = %{YAML::Tiny::LoadFile($config_file)};
  } or croak "Can't parse $config_file."; 
} else {
  croak "No config file found, exiting.\n";
}
  
## Merge config file into %config, then CLI.
%configs = ( %configs, %file_configs );
unless ( $book_dir ) {
  $book_dir = $configs{book_dir};
}
if ( ! -d $book_dir ) {
  mkdir $book_dir;
}

unless ( $report_dir ) {
  $report_dir = $configs{report_dir};
}
if ( ! -d $report_dir ) {
  mkdir $report_dir;
}

# Set the main variables.
my $sections_dir    = $configs{section_dir};

# Munge title into a reasonable filename.
$configs{file_name} = file_name_from_title( $configs{title} );

## And away we go!
opendir( my $dir, $sections_dir) or croak "Can't open $sections_dir: $!";

my $book = Book::Collate::Book->new( 
  author      => $configs{author}, 
  book_dir    => $configs{book_dir},
  file_name   => $configs{file_name},
  output_dir  => $configs{output_dir},
  report_dir  => $configs{report_dir},
  title       => $configs{title}, 
  custom_word_file  => $configs{custom_word_file},
  weak_word_file    => $configs{weak_word_file},
);

my $t = $book->title();
## Build sections and put them into the Book.
# This would be cool for a builder object.
my $section_number = 1;
my @files = sort( readdir( $dir ));
foreach my $file (@files) {
  if ( -f "$sections_dir/$file" ) {
    my $raw_data; 
    my $opened  = open( my $fh, '<', "$sections_dir/$file") 
      or croak "Can't open $sections_dir/$file: $!";
    if ( $opened ) {
      local $/ = undef;
      $raw_data = <$fh>;
      close($fh);
    }
    my $section = Book::Collate::Section->new(
      number      => $section_number,
      raw_data    => $raw_data,
      has_header  => 1,
      filename    => $file,
    );
    $book->add_section($section);
    $section_number++;    
  }
} 

close($dir);

$book->write_text; 
Book::Collate::Writer::Report->write_report_book($book);


