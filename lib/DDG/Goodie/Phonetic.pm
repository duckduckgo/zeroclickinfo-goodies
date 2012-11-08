package DDG::Goodie::Phonetic;
# ABSTRACT: Take a string and spell it out phonetically using the NATO alphabet

use DDG::Goodie;

triggers start => 'phonetic';

zci is_cached => 1;

primary_example_queries 'phonetic what duck';
description 'spell a string phonetically with the NATO alphabet';
name 'Phonetic';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Phonetic.pm';
category 'reference';
topics 'special_interest';
attribution github    => [ 'http://github.com/robotmay', 'Robert May' ],
            twitter => [ 'http://twitter.com/robotmay', 'robotmay' ];

handle remainder => sub {
  sub components {
    $_ = lc($_);
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
    my @chars = grep { $_ ~~ %nato } split(//, $_);
    my @components = map { $nato{ $_ } } @chars;
    return join("-", @components);
  }

  if ($_) {
    my @words = split(/\s+/, $_);
    my @phonetics = map { components($_) } @words;
    return "Phonetic: " . join(" ", @phonetics);
  }
  return;
};

1;
