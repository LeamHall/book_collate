# name:     words.t
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

done_testing();

