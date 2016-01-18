package DDG::Goodie::Phonetic;
# ABSTRACT: Take a string and spell it out phonetically using the NATO alphabet

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::WhatIs';

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

my $matcher = wi_custom({
    groups => ['prefix', 'imperative'],
    options => {
        command => qr/phonetic/i,
    },
});

handle query_raw => sub {
    my $query = shift;
    my $match = $matcher->match($query) // return;
    my $value = $match->{primary};
    my @words = split(/\s+/, lc $value);
    my @phonetics = map { components($value) } @words;
    return "Phonetic: " . join(" ", @phonetics);
};

1;
