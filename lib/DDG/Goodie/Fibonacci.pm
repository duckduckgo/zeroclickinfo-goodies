package DDG::Goodie::Fibonacci;
# ABSTRACT: n-th Fibonacci number

use strict;

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate qw(ordsuf);

triggers any => 'fib', 'fibonacci';

zci answer_type => 'fibonacci';
zci is_cached   => 1;

primary_example_queries 'fib 7';
secondary_example_queries 'fibonacci 33';
description 'Returns the n-th element of Fibonacci sequence';
attribution github => ['https://github.com/koosha--', 'koosha--'];
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Fibonacci.pm';
topics 'math';
category 'calculations';

my @fib = (0, 1);

handle remainder => sub {
    s/^\s+//;
    s/\s+$//;
    return unless /^(?:what(?:'s| is) the )?(?<which>\d+)(?:th|rd|st)?(?: number)?(?: in the (?:series|sequence))?\??$/ && $1 <= 1470;
    my $n = $+{'which'};
    # Instead of calling a typical recursive function,
    # use simple dynamic programming to improve performance
    if ($#fib < $n) {
        for my $i ($#fib .. $n) {
            $fib[$i] = $fib[$i - 1] + $fib[$i - 2];
        }
    }

    my $suf = ordsuf($n);
    return "The $n$suf fibonacci number is ${fib[$n]} (assuming f(0) = 0).",
      structured_answer => {
        input     => [$n . $suf],
        operation => 'Fibonacci number',
        result    => $fib[$n],
      };
};

1;
