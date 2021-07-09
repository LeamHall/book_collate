#!/usr/bin/env perl

# name:     scrub.pl
# version:  0.0.1
# date:     20210709
# author:   Leam Hall
# desc:     Sample code for scrubbing text files.

# Notes:
#   1. Requires an output directory so that it can be used in a for loop.
#   

# Usage:
#   scrub.pl <file>
#
#   - or -
#
#   for file in `ls *.txt`
#   do
#     scrub.pl $file
#   done

use strict;
use warnings;

use File::Basename;

my $infile_name = $ARGV[0];
my $outfile_name  = basename($infile_name);
my $outdir        = 'output';

open my $ofh, '>', "${outdir}/$outfile_name" or croak "Can't open $outfile_name in $outdir: $!";
open my $ifh, '<', $ARGV[0] or croak "Can't open $ARGV[0]: $!";
while ( readline($ifh )){

    # Skip these lines. Similar to  egrep -v "this|that|the other".
    next if m/(
    Spoiler               |
    Username A            |
    Username B            |
    Some string           |
    Some other string
  )/mx;

    # Add or change spacing around delimiters that start sections.
    s/ ^\[/\n\n\[ /mx;

    # Get rid of special characters that snuck in.
    s/Â//gmx;

    # Change names to protect the guilty.
    s/Cruella/Cinderella/gmx;

    # Write the file.
    print $ofh $_;
}

close $ofh;
close $ifh;
