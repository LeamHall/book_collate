#!/usr/bin/env perl

# name:     build_word_hash.pl
# version:  0.0.1
# date:     20210731
# author:   Leam Hall
# desc:     Creates a hash from a word list file.

# Notes:
#   1. The output needs to be put into a file, either directly or copied.
#   2. The lower case word is the hash key.
#   3. Each line of the file is one 'word'.
#   4. Blank lines, or lines with "#", are ignored.
#   5. Not sure how, if at all, it handles UTF-8.

# Usage:
#   build_word_list.pl <file> <key>
#
# Mass usage:
#   # Example filename tmp/fry_1.txt.     YMMV
#
#   for file in `ls tmp/fry_*` 
#     do f=`basename $file |sed 's/\.txt//'`
#     demo/build_word_hash.pl $file fry $f >> tmp/words.fry
#   done
#
#   # Add words.fry to you dataset.

use strict;
use warnings;

die "I need file, key, and value" unless @ARGV == 3;

my $file  = $ARGV[0];
my $key   = $ARGV[1];
chomp $key;
my $value = $ARGV[2];
chomp $value;

open my $ifh, '<', $file or die "Can't open $file: $!";
foreach my $word ( <$ifh> ){
  next if $word =~ m/(^\s*$|#)/;
  chomp $word;  
  $word = lc($word);
  print '$' . $key . '{"' . $word . '"} = "' . $value . '";' . "\n";
}

close $ifh;
