package DDG::Goodie::Fibonacci;

use strict;

use DDG::Goodie;

triggers any => 'fib', 'fibonacci';
zci is_cached => 1;
zci answer_type => 'fibonacci';

primary_example_queries 'fib 7';
secondary_example_queries 'fibonacci 33';
description 'Returns the n-th element of Fibonacci sequence';
attribution github => ['https://github.com/koosha--', 'koosha--'],
			twitter => '_koosha_';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Fibonacci.pm';
topics 'math';

handle remainder => sub {
    s/^\s+//;
    s/\s+$//;
    return unless /^\d+$/ && $_ <= 1470;
    my @fib;
    $#fib = $_;
    $fib[0] = 0;
    $fib[1] = 1;
    # Instead of calling a typical recursive function,
    # use simple dynamic programming to improve performance
    for my $i (2..$#fib) {
        $fib[$i] = $fib[$i - 1] + $fib[$i - 2];
    }
    return "fib($_) = ${fib[$_]} with f(0) = 0";
};

1;
