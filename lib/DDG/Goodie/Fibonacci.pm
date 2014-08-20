package DDG::Goodie::Fibonacci;
# ABSTRACT: n-th Fibonacci number

use strict;

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate qw(ordsuf);

triggers any => 'fib', 'fibonacci';
zci is_cached => 1;
zci answer_type => 'fibonacci';

primary_example_queries 'fib 7';
secondary_example_queries 'fibonacci 33';
description 'Returns the n-th element of Fibonacci sequence';
attribution github => ['https://github.com/koosha--', 'koosha--'],
            twitter => ['https://github.com/_koosha_', '_koosha_'];
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Fibonacci.pm';
topics 'math';
category 'calculations';

handle remainder => sub {
    s/^\s+//;
    s/\s+$//;
    return unless /^(?:what(?:'s| is) the )?(\d+)(?:th|rd|st)?(?: number)?(?: in the (?:series|sequence))?\??$/ && $1 <= 1470;
    my @fib;
    my $n = $1;
    $#fib = $n;
    $fib[0] = 0;
    $fib[1] = 1;
    # Instead of calling a typical recursive function,
    # use simple dynamic programming to improve performance
    for my $i (2..$#fib) {
        $fib[$i] = $fib[$i - 1] + $fib[$i - 2];
    }
    my $suf = ordsuf($_);
    return "The $n$suf fibonacci number is ${fib[$n]} (assuming f(0) = 0).",
           html => "The $n<sup>$suf</sup> fibonacci number is ${fib[$n]} (assuming f(0) = 0).";
};

1;
