package Book::Collate::Writer::Report;

use 5.006;
use strict;
use warnings;

=head1 NAME

Book::Collate::Writer::Report

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = 'v0.0.1';


=head1 SYNOPSIS

Given a file name, a report directory name, and a data object that includes report data,
writes the report.


=head1 EXPORT

A list of functions that can be exported.  You can delete this section
if you don't export anything, such as for a purely object-oriented module.

=head1 SUBROUTINES/METHODS


=head2 write_fry_stats

Produces a string based on Fry word usage.

=cut

sub write_fry_stats {
  my ( $word_list, $custom_word_list ) = @_;
  my %fry_used  = _generate_fry_stats( $word_list, $custom_word_list );
  my $string    = "Fry Word Usage: \n";
  $string       .= "  Used   " . $fry_used{fry}     . "\n";
  $string       .= "  Custom " . $fry_used{custom}  . "\n";
  $string       .= "  Miss   " . $fry_used{miss}    . "\n";
  return $string;
}

=head2 write_report_book

Takes a book object, iterates through the sections, and writes the reports.

=cut

sub write_report_book {
  # Test if given a book object.
  my ($self, $book)  = @_;
  my %word_list;
  my %custom_word_list;
  my $file = $book->custom_word_file();
  if ( defined($book->custom_word_file() ) ){
    %custom_word_list = _generate_custom_word_data($book->custom_word_file());
  }
  # This assumes it is given a book object, which has section objects.
  foreach my $section ( @{$book->sections()} ){
    my $section_report_file = $book->report_dir . "/report_" . $section->filename();
    open( my $section_file, '>', $section_report_file ) or die "Can't open $section_report_file: $!";
    %word_list = ( %word_list, $section->word_list() );
    print $section_file write_report_section($section, \%custom_word_list);
    close($section_file);
  }
  my $book_report_file = $book->report_dir . "/book_report.txt";
  open( my $book_file, '>', $book_report_file ) or die "Can't open $book_report_file: $!";
  print $book_file  write_fry_stats(\%word_list, \%custom_word_list);
  close $book_file;
  return;
}

=head2 write_report_section

Takes a section object and returns the stringified report.

=cut

sub write_report_section {
  my $self    = shift;
  # Test if given a section object.
  my $custom_word_list = shift;
  my %custom_word_list = %$custom_word_list;
  my $string  = "Grade Level:             " . $self->grade_level() . "\n";
  $string     .= "Average Word Length:     " . $self->avg_word_length() . "\n";
  $string     .= "Average Sentence Length  " . $self->avg_sentence_length() . "\n";

  my %word_list = $self->{_report}->word_list();
  $string     .= write_fry_stats(\%word_list, \%custom_word_list);
  $string     .= "Word Frequency List:\n";
  my %sorted_word_list = $self->{_report}->sorted_word_list();
  my @unsorted_keys = ( keys %sorted_word_list );
  my @sorted_keys = reverse ( sort { $a <=> $b } @unsorted_keys );
  my $max_keys = 25;
  foreach my $count ( @sorted_keys ){
    $string .= "  $count  ";
    foreach my $word ( @{$sorted_word_list{$count}} ){
      $string .= " $word";
    }
    $string .= "\n";
    $max_keys -= 1;
    last unless $max_keys;
  }
  return $string;
}



=head1 AUTHOR

Leam Hall, C<< <leamhall at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to L<https://github.com/LeamHall/book_collate/issues>.


=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Book::Collate::Writer::Report


You can also look for information at:

=over 4

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/.>

=item * Search CPAN

L<https://metacpan.org/release/.>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2021 by Leam Hall.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1; # End of Book::Collate::Writer::Report
