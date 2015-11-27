package DDG::Goodie::PrimeNumber;
# ABSTRACT: generate prime numbers in the requested range.

use DDG::Goodie;
use Math::Prime::Util 'primes';
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
attribution github => ["haojunsui", "Haojun Sui"],
            github => ["https://github.com/haojunsui", "Haojun Sui"],
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
        id => "prime_number",
        name => "Answer",
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

