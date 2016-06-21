package DDG::Goodie::Fibonacci;
# ABSTRACT: n-th Fibonacci number

use strict;

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate qw(ordsuf);
use Math::NumSeq::Fibonacci;
use Math::BigInt;

triggers any => 'fib', 'fibonacci';

zci answer_type => 'fibonacci';
zci is_cached   => 1;

sub answer {
    my ($text_ans, $title, $subtitle) = @_;

    return $text_ans, structured_answer => {
        data => {
            title => "$title",
            subtitle => "$subtitle"
        },
        templates => {
            group => 'text'
        }
    };
}

my $ith_limit = 25000;      # limit for nth fibonacci numbers
my $pred_limit = 10**22;    # limit for if n is a fibonacci number
my $fib_seq = Math::NumSeq::Fibonacci->new;

handle remainder_lc => sub {
    # check "what is the nth fibonacci number"
    if (/^(?:what(?:'s| is) the )?(?<which>\d+)(?:st|nd|rd|th)?(?: number)?(?: in the (?:series|sequence))?\??$/ && $1 <= $ith_limit) 
    {
        my $n = $+{'which'};
        my $val = $fib_seq->ith($n);
        my $suf = ordsuf($n);
        my $text_answer ="The $n$suf fibonacci number is $val (assuming f(0) = 0)";

        return answer($text_answer, $val, "$n$suf Fibonacci number");
    }
    # check "is n a fibonacci number"
    elsif (/^is (?<which>\d+) (?:a|in the)? ?(?:number|sequence)?\??$/ && $1 <= $pred_limit)
    {
        my $n = $+{'which'};
        my $val = $fib_seq->pred($n);
        my $is_fib = $val ? "is" : "is not";
        my $text_answer ="$n $is_fib a Fibonacci number";

        return answer($text_answer, $val ? "Yes" : "No", $text_answer);
    }
    else
    {
        return;                 # didn't match anything
    }
};

1;
