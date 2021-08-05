# name:     Words.t
# version:  0.0.1
# date:     20210721
# author:   Leam Hall
# desc:     Provides word lists

## CHANGELOG

use strict;
use warnings;
use lib "lib";
use Book::Collate;

use Test::More;
use Scalar::Util qw/reftype/;

use_ok( 'Book::Collate::Words' ) or die $!;

is( $Book::Collate::Words::fry{"had"}, "fry_1", "Pull value from Words::fry" );

my %test_list = %Book::Collate::Words::fry;
is ( $test_list{"had"}, "fry_1", "Fry words exportable to hash" );

my $custom_file = 't/data/custom_words.txt';
my %test_custom = Book::Collate::Words::build_hash_from_file($custom_file);
is( ref(%test_custom), ref( my %hash), "build_hash_from_file returns a hash"); 
#is( reftype(%test_custom), Scalar::Util::reftype {}, "build_hash_from_file returns a hash"); 
is( %test_custom, 3, "Custom list contains three keys");
is( 1, defined( $test_custom{blagy}), "Specific custom key is already defined");
is( 0, $test_custom{blagy}, "Correct value for specific custom key");

done_testing();

