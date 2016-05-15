package DDG::Goodie::Fibonacci;
# ABSTRACT: n-th Fibonacci number

use strict;

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate qw(ordsuf);

triggers any => 'fib', 'fibonacci';

zci answer_type => 'fibonacci';
zci is_cached   => 1;

my @fib = (0, 1);

handle remainder => sub {
    s/^\s+//;
    s/\s+$//;
    return unless /^(?:what(?:'s| is) the )?(?<which>\d+)(?:th|rd|st)?(?: number)?(?: in the (?:series|sequence))?\??$/ && $1 <= 1470; #' (hack for broken syntax highlighting)
    my $n = $+{'which'};
    
    if ($#fib < $n) {
        for my $i ($#fib .. $n) {
            $fib[$i] = $fib[$i - 1] + $fib[$i - 2];
        }
    }

    my $suf = ordsuf($n);
    my $text_answer ="The $n$suf fibonacci number is ${fib[$n]} (assuming f(0) = 0).";
    return $text_answer, structured_answer => {
        data => {
            title => $fib[$n],
            subtitle => "$n$suf Fibonacci number"  
        },
        templates => {
            group => 'text'
        }
    };
};

1;
