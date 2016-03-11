package DDG::Goodie::EvenOrOdd;
# ABSTRACT: Tell if a number is even or odd

use DDG::Goodie;
use strict;

zci answer_type => "even_or_odd";
zci is_cached   => 1;

name 'EvenOrOdd';
description 'Check if a numnber is even or odd';
primary_example_queries 'is 200 even';
secondary_example_queries '-111     even?';
category 'calculations';
topics 'math';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EvenOrOdd.pm';
attribution github => ['https://github.com/FeiHong-Ren', 'FeiHong-Ren'];

# Triggers
triggers startend => "even", "odd", "even number", "odd number";

# Handle statement
handle query_lc => sub {
    my $query = /[is]?[\s]*(-?([\d]+))[\s]*(an\s)?(even|odd|even number|odd number)/;
    return unless $query;
    my $input = $1;
    my $output;
    if ($input%2 == 0){
        $output = "Even";
    }else {
        $output = "Odd";
    }
    return $output,
      structured_answer => {
      input     => [html_enc($input)],
      operation => 'Even or Odd',
      result    => html_enc($output)
      }; 
};

1;
