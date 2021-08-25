# name:     utils.t
# version:  0.0.1
# date:     20210817
# author:   Leam Hall
# desc:     Various utilities for the collate and report processes.

## CHANGELOG

use strict;
use warnings;
use lib "lib";
use Book::Collate;

use Test::More;
use Scalar::Util qw/reftype/;

use_ok( 'Book::Collate::Utils' ) or die $!; 

my $custom_file = 't/data/custom_words.txt';
my %test_custom = Book::Collate::Utils::build_hash_from_file($custom_file);
is( ref(%test_custom), ref( my %hash), "build_hash_from_file returns a hash"); 
is( %test_custom, 3, "Custom list contains three keys");
is( 1, defined( $test_custom{blagy}), "Specific custom key is already defined");
is( 0, $test_custom{blagy}, "Correct value for specific custom key");

is( "yes", Book::Collate::Utils::scrub_word("YES'!"), 
  "Scrubs exclamation and possive");


my $multi_value_custom_file = 't/data/multi_custom_words.txt';
my %test_multi_custom = Book::Collate::Utils::build_hash_from_file($multi_value_custom_file);
ok( $test_multi_custom{unu} eq 'esperanto', "Reads key and value from file" );

done_testing();

