package DDG::Goodie::PhoneAlphabet;
# ABSTRACT: Taking a phone number with letters in it and returning the phone number

use DDG::Goodie;

zci answer_type => 'phone_alphabet';
zci is_cached   => 0;

name "PhoneAlphabet";
description "Returns the phone number from a word phone number";
primary_example_queries "1-800-FUN-HACK to digits", "1-800-LAWYR-UP to phone number";
category 'reference';
topics 'special_interest';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PhoneAlphabet.pm";
attribution github => ["https://github.com/stevelippert", "Steve Lippert"],
            twitter => ["https://twitter.com/stevelippert", "stevelippert"];

# Triggers
triggers any => 'to digit', 'to digits', 'to phone', 'to phone number';

sub components {
    my %phoneAlphabet = (
      a => "2",
      b => "2",
      c => "2",
      d => "3",
      e => "3",
      f => "3",
      g => "4",
      h => "4",
      i => "4",
      j => "5",
      k => "5",
      l => "5",
      m => "6",
      n => "6",
      o => "6",
      p => "7",
      q => "7",
      r => "7",
      s => "7",
      t => "8",
      u => "8",
      v => "8",
      w => "9",
      x => "9",
      y => "9",
      z => "9"
    );

    my @components = map { defined $phoneAlphabet{$_} ? ($phoneAlphabet{$_}) : ($_) } split //, $_;
    return join("", @components);
}

handle remainder => sub {
    return unless $_;
    $_ = lc;
    my @words = split(//, $_);
    my @numbers = map { components($_) } @words;
    return "Phone Number: " . join("", @numbers);
};

1;
