# name:     section.t
# version:  0.0.5
# date:     20210821
# author:   Leam Hall
# desc:     Tests for the Section object.

## CHANGELOG
# 0.0.2   Moved data parsing into the object.
# 0.0.3   Added test for beginning multple blank lines.
# 0.0.4   Added tests for reports.
# 0.0.5   Added more tests for the _trim actions.

use strict;
use warnings;
use lib "lib";
use Book::Collate;

use Test::More;

use_ok( 'Book::Collate::Section' ) or die $!;

####
my $section   = Book::Collate::Section->new( 
  raw_data    => "[1429.123.0456] Nowhere
  Al looked around. It was interesting.",
  number      => 1,
  has_header  => 1,
  filename    => 'some_cool_filename.txt',
);

my $raw_data = "[1429.123.0456] Nowhere
  Al looked around. It was interesting.";

isa_ok( $section, 'Book::Collate::Section', 'Initial section');
is( $section->avg_sentence_length(), '3.00',  'Returns average sentence length');
is( $section->avg_word_length(),     '5.00',  'Returns Average word length');
is( $section->grade_level(),         7.21,    'Returns proper grade level');
is( $section->header(),              '[1429.123.0456] Nowhere', 'Returns header' );
is( $section->headless_data(),       'Al looked around. It was interesting.', 
  'Returns headless data');
is( $section->number(),              1, 'Returns section number' );
is( $section->raw_data(),            $raw_data, 'Returns data');
is( $section->sentence_count(),      2, 'Returns sentence count');
is( $section->word_count(),          6, 'Returns proper word count');
is( $section->filename(),            'some_cool_filename.txt', 'Returns file name' );


####
my $title_section = Book::Collate::Section->new(
  raw_data    => "TITLE: An odd event
  [1429.123.0457] Nowhere
  Al looked again, and he was there.",
  has_header  => 1,
);
isa_ok( $title_section, 'Book::Collate::Section',   'Title section');
is( $title_section->header(),  '[1429.123.0457] Nowhere', 
  'Title section returns header occuring after TITLE:');
is( $title_section->title(),   'An odd event',      'Title section returns title');
is( $title_section->avg_sentence_length(), '7.00',  'TEST Returns average sentence length');


my $headless_section = Book::Collate::Section->new(
  raw_data    => "TITLE: Another odd event
  Al looked again, and he was there.",
);
isa_ok( $headless_section, 'Book::Collate::Section', 'Headless section');
is( $headless_section->title(),             'Another odd event', 
  'Headless section returns title');
is( $headless_section->headless_data(),     'Al looked again, and he was there.', 
  'Headless section returns headless_data');

# Not sure why defined needs '' vice 0.
is ( defined($headless_section->header()),  '', 
  'Headless section returns undef for header()');

####
my $extra_lines_at_start_section = Book::Collate::Section->new(
  raw_data  => "




  [1429.123.0459] Nowhere
  Al was tired, and he looked nice.",
  has_header  => 1,
);
isa_ok( $extra_lines_at_start_section, 'Book::Collate::Section', 'Extra lines section');
is( $extra_lines_at_start_section->header(), '[1429.123.0459] Nowhere', 
  'Extra lines still finds header');

my $trimable_data = "    aaa  bbb  ccc  Cool!   ";
my $trim_section  = Book::Collate::Section->new (
  raw_data   => $trimable_data,
);
is($trim_section->raw_data, 'aaa  bbb  ccc  Cool!', "Trimmed the raw data");


####
my $extra_lines_everywhere = Book::Collate::Section->new(

  raw_data  => "

  TITLE:  Extra Lines!          


  [1429.123.0459] Nowhere        


  Al was tired, and he looked nice.        


  ",
  has_header  => 1,
);
isa_ok( $extra_lines_everywhere, 'Book::Collate::Section', 'Extra lines section');
is( $extra_lines_everywhere->title(),         'Extra Lines!', 
  'Extra lines section returns title');
is( $extra_lines_everywhere->header(),        '[1429.123.0459] Nowhere', 
  'Extra lines still finds header');
is( $extra_lines_everywhere->headless_data(), 'Al was tired, and he looked nice.', 
  'Extra lines has trimmed headless_data');

done_testing();

