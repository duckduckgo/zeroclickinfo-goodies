package DDG::Goodie::PrimeNumber;
# ABSTRACT: generate prime numbers in the requested range.

use DDG::Goodie;
use strict;
use POSIX;

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
    return unless ($_ =~ /^\!?(?:prime num(?:ber(?:s|)|) between|)[\s]*([-]{0,1}[\d\.]+|)(?: and|)[\s]*([-]{0,1}[\d\.]+|)$/i);

    my $start = $1 || 1;
    my $end   = $2 || 1;

    $start = 1000000000 if $start > 1000000000;
    $end = 1000000000 if $end > 1000000000;
    ($end, $start) = ($start, $end) if ($start > $end);
    
    my $s = ceil($start);
    my $e = floor($end);
    
    $s = 1          if $s <= 0;
    $s += 0;
    $e = 1          if $e <= 0;
    $e += 0;
    
    my @sieve = (1) x ($e + 1);
    my @primes = ();
    my $p = 2;
    my $j = 0;
    
    while ($p * $p <= $e) {
        $j = $p + $p;
        while ($j <= $e) {
            $sieve[$j] = 0;
            $j += $p;
        }
        $p += 1;
        while ($sieve[$p] == 0) {
            $p += 1;
        }
    }
    for ($p = $s; $p <= $e; $p++) {
        if ($sieve[$p] == 1) {
            push @primes, $p;
        }
    }
    
    return "None",
      structured_answer => {
        input     => [$start, $end],
        operation => 'Prime numbers between',
        result    => "None"
      } unless @primes;
      
    if ($primes[0] == 1){
        splice @primes, 0, 1;
    }
    
    return "None",
      structured_answer => {
        input     => [$start, $end],
        operation => 'Prime numbers between',
        result    => "None"
      } unless @primes;
    
    return join(", ", @primes),
      structured_answer => {
        input     => [$start, $end],
        operation => 'Prime numbers between',
        result    => join(", ", @primes)
      };
};

1;
