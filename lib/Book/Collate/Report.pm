package Book::Collate::Report;

use 5.006;
use strict;
use warnings;

=head1 NAME

Report

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = 'v0.0.1';


=head1 SYNOPSIS

Report Object

    use Report;

    my $report        = Report->new(
      headless_data   = $section->headless_data
    );

=head1 SUBROUTINES/METHODS

=head2 new

=cut

sub new {
 my ($class, %data) = @_;
  my $self    = {
    _data             => undef,
    _string           => $data{string},
    _words            => undef,
    _fry_used         => undef,
    _custom_word_file => undef,
  };
  bless $self, $class;

  (my $data       = $self->{_string}) =~ s/[;:!'"?.,]/ /g;
  $data           =~ s/ (d|ll|m|re|s|t|ve) / /g; 
  $data           =~ s/\s*(.*)\s*/$1/;
  $self->{_data}  = $data;
  $self->{_words} = [ split(/\s+/, $self->{_data}) ];
  $self->{_word_list}  = $self->word_list($self->{_words});
  $self->{_custom_word_list} = %{$self->custom_word_list()};
  $self->{_fry_used} = $self->_generate_fry_stats();
  return $self; 
}

=head2 avg_sentence_length

Returns the average sentence length

=cut

sub avg_sentence_length {
  my $self = shift;
  my $wc = $self->word_count;
  my $sc = $self->sentence_count;
  return sprintf( "%.2f", $self->word_count / $self->sentence_count );
}


=head2 avg_word_length

Returns the average word length

=cut

sub avg_word_length {
  my $self      = shift;
  my $character_count = 0;
  foreach my $word ( $self->words() ){
    $character_count += length($word);
  }
  return sprintf("%.2f", $character_count / $self->word_count );
}

=head2 custom_word_list

Returns a hash of custom words, or undef if no file provided.

=cut

sub custom_word_list {
  my ($self) = @_;
  my %custom_word_list;
  if ( defined($self->{_custom_word_file} ) ) {
    %custom_word_list = $self->_generate_custom_word_data(
      $self->{_custom_word_file} );
  };
  return \%custom_word_list;
  #return %custom_word_list;
}

=head2 _generate_custom_word_data

Creates a hash with custom words as keys

=cut

sub _generate_custom_word_data {
  my ( $file ) = @_;  
  my %hash = Book::Collate::Utils::build_hash_from_file($file);
  return %hash;
}

=head2 _generate_fry_stats

Gives a percentage of Fry list words used against the total unique words used.

=cut

sub _generate_fry_stats {
  my $self = shift;
  my %word_list = $self->word_list();
  my %custom_word_list; 
  if ( defined( $self->custom_word_list() ) ){
    %custom_word_list = %{$self->custom_word_list()};
  }
  my %fry_words = %Book::Collate::Words::fry;
  my %used_words;
  my %missed;
  my %fry_used = ( 
    fry     => 0,
    custom  => 0,
    miss    => 0,
  );  
  foreach my $word ( keys %word_list ){
    $word = Book::Collate::Utils::scrub_word($word);
    $used_words{$word} = 1;
  }   

  foreach my $word ( keys %used_words ){
    if ( defined($fry_words{$word}) ){
      $fry_used{fry}++;
    #} elsif ( defined($self->{_custom_word_list}{$word}) ){
    } elsif ( defined($custom_word_list{$word}) ){
      $fry_used{custom}++;
    } else {
      $fry_used{miss}++;
      $missed{$word} = 1;
    }   
  }
  return %fry_used;
}

=head2 grade_level

Returns the grade level.

=cut

sub grade_level {
  my $self = shift;
  my $sentence_average = $self->word_count / $self->sentence_count;
  my $word_average      = $self->syllable_count / $self->word_count;
  my $grade = 0.39 * $sentence_average ;
  $grade    += 11.8 * ( $word_average );
  $grade    -= 15.59;
  return sprintf("%.2f", $grade); 
}

=head2 sentence_count

Returns the number of sentences, based off the count of ".", "?", and "!" marks.

=cut

sub sentence_count {
  my $self = shift;
  my $str   = $self->{_string};
  return $self->{_string} =~ tr/[?!.]//;
}

=head2 sorted_word_list 

Returns a hash of lists, based on word frequency.

=cut

sub sorted_word_list {
  my $self    = shift;
  my %sorted_word_list;
  my %word_hash = $self->word_list();
  while ( my( $word, $count) = each %word_hash ) {
    $sorted_word_list{$count} = [] unless defined( $sorted_word_list{$count} );
    push ( @{$sorted_word_list{$count}}, $word );
  }
  foreach my $key ( keys %sorted_word_list ) {
    my @array = sort( @{$sorted_word_list{$key}} ) ;
    $sorted_word_list{$key} = [ sort( @{$sorted_word_list{$key}} ) ];
  }
  return %sorted_word_list;
}

=head2 syllable_count

Returns the number of syllables for a word.

=cut

sub syllable_count {
  my $self            = shift;
  my $syllable_count  = 0;
  foreach my $word ( $self->words ){
    $word   = lc($word);
    my $sc  = $word =~ tr/[aeiou]//;
    $sc     -= $word =~ m/(ee|ey$|oi|oo|ou)/;
    $sc     += 1 if $word =~ m/y$/; 
    $sc     -= 1 if $word =~ m/e$/; 
    $sc     = 1 if $sc < 1;

    $syllable_count        += $sc;
  } 
  return $syllable_count;
}


=head2 used_words

Returns a hash of words used in the text.

=cut

sub used_words {
  my  @word_list  = @_; 
  my %used_words;
  foreach my $word ( @word_list ){
    $word = lc($word);
    $used_words{$word} = 1;  
  }

  return %used_words;
}


=head2 words

Returns array of words, in order.

=cut

sub words {
  return @{$_[0]->{_words}};
}

=head2 word_count

Returns the number of words.

=cut

sub word_count {
  my $self        = shift;
  return scalar($self->words);
}

=head2 word_list 

Returns hash of lowercase words as keys, count as values.

=cut

sub word_list {
  my ( $self, @words)  = @_;
  my %word_list;
  foreach my $word ( @words ) {
    $word = lc($word);
    $word_list{$word} += 1;
  }
  return %word_list;
}



=head1 AUTHOR

Leam Hall, C<< <leamhall at gmail.com> >>

=head1 BUGS

Please report any bugs or feature requests to L<https://github.com/LeamHall/book_collate/issues>.  




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc lib/Book/Collate/Report


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

1; # End of Report
