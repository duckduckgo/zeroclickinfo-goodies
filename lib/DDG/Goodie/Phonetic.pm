package DDG::Goodie::Phonetic;
# ABSTRACT: Take a string and spell it out phonetically using the NATO alphabet

use strict;
use DDG::Goodie;

triggers start => 'phonetic';

zci is_cached => 1;

sub components {
    my %nato = (
      a => "Alfa",
      b => "Bravo",
      c => "Charlie",
      d => "Delta",
      e => "Echo",
      f => "Foxtrot",
      g => "Golf",
      h => "Hotel",
      i => "India",
      j => "Juliet",
      k => "Kilo",
      l => "Lima",
      m => "Mike",
      n => "November",
      o => "Oscar",
      p => "Papa",
      q => "Quebec",
      r => "Romeo",
      s => "Sierra",
      t => "Tango",
      u => "Uniform",
      v => "Victor",
      w => "Whiskey",
      x => "Xray",
      y => "Yankee",
      z => "Zulu",
      1 => "One",
      2 => "Two",
      3 => "Three",
      4 => "Four",
      5 => "Five",
      6 => "Six",
      7 => "Seven",
      8 => "Eight",
      9 => "Nine",
      0 => "Zero"
    );

    my @components = map { defined $nato{$_} ? ($nato{$_}) : () } split //, $_;
    return join("-", @components);
}

handle remainder => sub {
    return unless $_;
    $_ = lc;
    my @words = split(/\s+/, $_);
    my @phonetics = map { components($_) } @words;
    my $string_answer = "Phonetic: " . join(" ", @phonetics);
    my $title = join(" ", @phonetics);
    my $subtitle = "Phonetic: " . $_;
    return $string_answer, structured_answer => {
        data => {
            title => $title,
            subtitle => $subtitle,
        },
        templates => {
            group => 'text',
        }
    }
};

1;
