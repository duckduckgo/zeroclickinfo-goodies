package DDG::Goodie::PrimeNumber;
# ABSTRACT: generate prime numbers in the requested range.

use DDG::Goodie;
use strict;

zci answer_type => "prime";
zci is_cached   => 1;

name "PrimeNumber";
description "Generates prime numbers";
primary_example_queries "prime numbers between 1 and 12", "prime numbers";
category "computing_tools";
topics "cryptography";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PrimeNumber.pm";
attribution github => ["shjnyr", "Haojun Sui"],
            github => ["https://github.com/shjnyr", "shjnyr"],
            twitter => ["https://twitter.com/Charles_Sui", "Haojun Sui"];

# Triggers
triggers start => "prime", "prime numbers";

handle query_lc => sub {
    # q_check (as opposed to q_internal) Allows for decimals.
    return unless ($_ =~ /^\!?(?:prime(?: num(?:bers|)|)(?: between|))( [\d\.]+|)(?: and|)( [\d\.]+|)$/i);

    my $start = $1 || 0;
    my $end   = $2 || 0;

    $start = 1000000000 if $start > 1000000000;
    $start = 0          if $start < 0;
    $start += 0;

    $end = 1000000000 if $end > 1000000000;
    $end = 0          if $end < 0;
    $end = 1          if !$end;
    $end += 0;

    ($end, $start) = ($start, $end) if ($start > $end);

    my @sieve = (1) x ($end + 1);
    my @primes = ();
    my $p = 2;
    my $j = 0;
    
    while ($p * $p <= $end) {
        $j = $p + $p;
        while ($j <= $end) {
            $sieve[$j] = 0;
            $j += $p;
        }
        $p += 1;
        while ($sieve[$p] == 0) {
            $p += 1;
        }
    }
    for ($p = $start; $p < $end; $p++) {
        if ($sieve[$p] == 1) {
            push @primes, $p;
        }
    }
    if ($primes[0] == 1){
        splice @primes, 0, 1;
    }
    
    return join(",  ", @primes) . " (prime numbers)",
      structured_answer => {
        input     => [$start, $end],
        operation => 'Prime numbers between',
        result    => join(",  ", @primes)
      };
};

1;
