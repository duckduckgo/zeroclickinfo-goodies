package DDG::Goodie::Fibonacci;
# ABSTRACT: n-th Fibonacci number

use strict;

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate qw(ordsuf);
use Math::NumSeq::Fibonacci;

triggers any => 'fib', 'fibonacci';

zci answer_type => 'fibonacci';
zci is_cached   => 1;

handle remainder_lc => sub {
    s/^\s+//;
    s/\s+$//;
    my $limit = 25000; # larger numbers degrade performance
    
    return unless /^(?:what(?:'s| is) the )?(?<which>\d+)(?:th|rd|st|nd)?(?: number)?(?: in the (?:series|sequence))?\??$/ && $1 <= $limit;
    my $n = $+{'which'};
    my $fib_seq = Math::NumSeq::Fibonacci->new;
    my $val = $fib_seq->ith($n);
    
    my $suf = ordsuf($n);
    my $text_answer ="The $n$suf fibonacci number is $val (assuming f(0) = 0).";
    return $text_answer, structured_answer => {
        data => {
            title => $val,
            subtitle => "$n$suf Fibonacci number"  
        },
        templates => {
            group => 'text'
        }
    };
};

1;
