package DDG::Goodie::PrimeNumber;
# ABSTRACT: generate prime numbers in the requested range.

use DDG::Goodie;
use Math::Prime::Util 'primes';
use strict;
use POSIX;

zci answer_type => "prime";
zci is_cached   => 1;

# Triggers
triggers start => "prime", "prime numbers";

# 2015.12.29 (caine): moved max from 1B to 1M.
my $max = 1_000_000;

handle query_lc => sub {
    # q_check (as opposed to q_internal) Allows for decimals.
    return unless ($_ =~ /^\!?(?:prime num(?:ber(?:s|)|) between|)[\s]*([-]{0,1}[\d\.]+|)(?: and|)[\s]*([-]{0,1}[\d\.]+|)$/i);

    my $start = $1 || 1;
    my $end   = $2 || 1;

    $start = $max if $start > $max;
    $end = $max if $end > $max;
    ($end, $start) = ($start, $end) if ($start > $end);

    my $s = ceil($start);
    my $e = floor($end);

    $s = 1 if $s <= 0;
    $s += 0;
    $e = 1 if $e <= 0;
    $e += 0;

    my $pList = join(", ", @{primes($s, $e)});

    if ($pList eq "") {
        $pList = "None";
    }

    return $pList,
      structured_answer => {
        data => {
            title => "Prime numbers between $start and $end",
            description => $pList
        },
        templates => {
            group => "text",
            options => {
                chompContent => 1
            }
        }
      };
};

1;

