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

use_ok( 'Book::Collate::Words' ) or die $!;


done_testing();

