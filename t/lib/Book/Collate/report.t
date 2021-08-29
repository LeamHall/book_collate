# name:     report.t
# version:  0.0.1
# date:     20210116
# author:   Leam Hall
# desc:     Generates reports for the Section objects.

## CHANGELOG

use strict;
use warnings;
use lib "lib";
use Book::Collate;

use Test::More;

use_ok( 'Book::Collate::Report' ) or die $!;

my $data              = "Al looked around; wow! It'd be \"nice\" if he joined her.";
my $custom_word_file  = 't/data/custom_words.txt';
my %custom_word_list  = Book::Collate::Utils::build_hash_from_file($custom_word_file);

my $report  = Book::Collate::Report->new (
  string     => $data, 
  custom_word_file  => $custom_word_file,
  custom_words      => \%custom_word_list,
);
isa_ok( $report, 'Book::Collate::Report', 'Initial Report');

ok($report->word_count          == 11,    'Has the right number of words' );
ok($report->sentence_count      == 2,     'Has the right number of sentences' );
ok($report->grade_level         == 1.57,  'Has the right grade level' );
ok($report->syllable_count      == 14,    'Has the right number of syllables' );
ok($report->avg_sentence_length == 5.50,  'Has the right average sentence length' );
ok($report->avg_word_length     == 3.45,  'Has the right average word length' );

my %used_words = $report->used_words(qw/one TWO two three three/);
ok($used_words{two}             == 1,     'Creates used_word hash');

my @test_words  = qw/Al looked around wow It be nice if he joined her/;
ok($report->words               eq @test_words, 'Has the right word list' );

# Working on Fry and Custom word reporting.
my $fc_data  = "Al Domici looked around; wow! It'd be nice if Wilbur Lefron joined her.";
my $fc_custom_word_file = 't/data/custom_words.txt';

my $fc_report  = Book::Collate::Report->new (
  string            => $fc_data, 
  custom_word_file  => $fc_custom_word_file,
  custom_words      => \%custom_word_list,
);
isa_ok( $fc_report, 'Book::Collate::Report', 'Initial Report');
my %fry_stats = $fc_report->_generate_fry_stats();
ok($fry_stats{fry}     == 6,   'Fry stats fry is 6'    );
ok($fry_stats{custom}  == 3,   'Fry stats custom is 3' );
ok($fry_stats{miss}    == 4,   'Fry stats miss is 4'   );

done_testing();

__DATA__;

my %word_list_test = (
  again   => 2,
  al      => 2,
  and     => 1,
  at      => 1,
  happy   => 1,
  he      => 3,
  looked  => 2,
  looking => 1,
  she     => 1,
  there   => 1,
  was     => 3,
);

my $word_list_report = Report->new (
  string  => "Al looked again, and he was there. He was looking at Al, again. She was happy he looked.",
);
 
my %word_list_created = $word_list_report->word_list();
is_deeply( \%word_list_test, \%word_list_created, "Word list hashes are the same" );

my %sorted_word_list_test = (
  3 => ['he', 'was'],
  2 => ['again', 'al', 'looked'],
  1 => ['and', 'at', 'happy', 'looking', 'she', 'there'],
);
my %sorted_word_list_created = $word_list_report->sorted_word_list();
is_deeply( \%sorted_word_list_test, \%sorted_word_list_created, "Sorted word list hashes at the same" );



