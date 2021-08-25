package Book::Collate::Utils;


use 5.006;
use strict;
use warnings;

use Exporter 'import';
our @EXPORT_OK = qw/ build_hash_from_file scrub_word /;

=head1 NAME

Words

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = 'v0.0.1';

=head1 SYNOPSIS

Various infrastructure bits to build data structures and what-not.

=head1 Subroutines/Methods

=head2 build_hash_from_file

Given a valid file with one valid hash key value per line, optionally with 
a space seperated value, returns a hash. The default value is '0'. 

=cut

sub build_hash_from_file {
  my ($file) = @_;
  my %hash;
  open my $fh, '<', $file or die "Can't open $file: $!";
  for my $line ( <$fh> ){
    chomp $line;
    next if $line =~ m/^#/;
    next unless $line; 
    $line = lc($line);
    my ($key, $value) = split(/\s+/, $line);
    $value //= 0;
    $hash{$key} = $value; 
  } 
  return %hash;
}

=head2 scrub_word

Scrubs a series of characters of case and punctuation.
[TODO] Return a list, with the base word at index 0.
 
=cut

sub scrub_word {
  my ($word)  = @_; 
  chomp $word;
  $word =~ s/["?!.]//g;
  $word =~ s/'$//;
  $word =~ s/\-$//;
  $word = lc($word);
  return $word;
}

=head1 AUTHOR

Leam Hall, C<< <leamhall at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to L<https://github.com/LeamHall/book_collate/issues>.  



=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc lib/Book/Collate/Utils


You can also look for information at:

=over 4

=item * GitHub Project Page

L<https://github.com/LeamHall/book_collate>

=back


=head1 ACKNOWLEDGEMENTS

Besides Larry Wall, you can blame the folks on IRC Libera#perl for this stuff existing.


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2021 by Leam Hall.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1;
