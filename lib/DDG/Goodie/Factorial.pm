package DDG::Goodie::Factorial;
# ABSTRACT: n factorial

use strict;
use DDG::Goodie;

use List::Util qw(reduce);
use bigint;

zci answer_type => "factorial";
zci is_cached   => 1;

name "Factorial";
description "Returns Factorial of n";
primary_example_queries "factorial 7", "7 factorial";
secondary_example_queries "12 fact";
topics 'math';
category 'calculations';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Factorial.pm";
attribution github => ["https://github.com/codenirvana", "Udit Vasu"],
            twitter => "uditdistro";

triggers any => "factorial", "fact";

handle remainder => sub {
    my $n = $_;
    
    return unless $n =~ /^\d+$/;
    
    $n = int($n);
    
    my $fact = '1';
    $fact = reduce { $a * $b } 1 .. $n if ($n > 0);
    
    return "Factorial of $n is $fact",
      structured_answer => {
        input     => [$n],
        operation => 'Factorial',
        result    => $fact
    };

};

1;
