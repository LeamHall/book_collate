# name:     book.t
# version:  0.0.1
# date:     20201219
# author:   Leam Hall
# desc:     Tests for Book object.

use strict;
use warnings;
use lib "lib";
use Book::Collate;
use Test::More;

my $ns_blurb    = 
"        Academic over-achiever Dede McKenna needs the girl that barely made 
        it into Firster Academy; can their friendship survive bullies, 
        boys, and felonies?
";
my $ns_image    = 'images/navaksen_low.jpg';
my $ns_url      = 'https://www.amazon.com/NavakSen-Firster-Academy-Book-1-ebook/dp/B08SKPNMPH';
my $report_dir  = 't/data/reports';
my $section_1   = Book::Collate::Section->new( 
  raw_data      => "[1429.123.0456] Nowhere
  Al looked around. It was interesting.",
  number        => 1,
  has_header    => 1,
);
my $section_2   = Book::Collate::Section->new( 
  raw_data      => "[1429.123.0546] Nowhere
  Al looked at Wilbur, he was interesting.",
  number        => 1,
  has_header    => 1,
);
my $report_2_text =
"Grade Level: 7.37
Word Frequency List:
  1   al at he interesting looked was wilbur
";

my $book      = Book::Collate::Book->new(
  author      => 'Leam Hall',
  book_dir    => '/home/leam/mybook',
  blurb_file  => 't/data/navaksen_blurb.txt',
  file_name   => 'al_rides_again',
  image       => 'images/navaksen_low.jpg',
  output_dir  => 't/data/book',
  report_dir  => $report_dir,
  title       => 'Al rides again',
  url         => $ns_url,
  custom_word_file => 'data/custom_words.txt',
);

$book->add_section( $section_1 );
$book->add_section( $section_2 );

use_ok( 'Book::Collate::Book' ) or die $!;
isa_ok( $book, 'Book::Collate::Book');

is( $book->author,            'Leam Hall',          'Returns author' );
is( $book->blurb,             $ns_blurb,            'Returns book blurb' );
is( $book->book_dir,          '/home/leam/mybook',  'Returns book_dir' );
is( $book->output_dir,        't/data/book',        'Returns output_dir' );
is( $book->report_dir,        't/data/reports',     'Returns report_dir' );
is( $book->file_name,         'al_rides_again',     'Returns book file_name' );
is( $book->image,             $ns_image,            'Returns the image location' );
is( $book->title,             'Al rides again',     'Returns book title' );
is( $book->url,               $ns_url,              'Returns URL' );
is( @{$book->sections},       2,                    'Returns section count' );
is( $book->custom_word_file, 'data/custom_words.txt', 
  'Returns custom word file' );

my @test_word_list = qw/one two three four five/;
my %test_word_hash = $book->add_words(\@test_word_list);
is( $book->{_words}{two},   1,                      'Adds word to _word hash');

#$book->write_report();
#my $actual_report_file = do {
#  my $file = 't/data/reports/report_2.txt';
#  local $/ = undef;
#  open my $fh, '<', $file or die "Could not open $file: $!";
#  <$fh>;
#};
#ok( $actual_report_file eq $report_2_text,  'Writes section report file correctly');

#my $test_book_text =
#"
#__section_break__
#Chapter 001
#
#[1429.123.0456] Nowhere
#
#Al looked around. It was interesting.
#
#
#__section_break__
#Chapter 002
#
#[1429.123.0546] Nowhere
#
#Al looked at Wilbur, he was interesting.
#
#";
#my $actual_book_file = do {
#  my $file = 't/data/book/al_rides_again.txt';
#  local $/ = undef;
#  open my $fh, '<', $file or die "Could not open $file: $!";
#  <$fh>;
#};
#ok( $actual_book_file eq $test_book_text,  'Writes book file correctly');
#$book->write_text();

done_testing();

