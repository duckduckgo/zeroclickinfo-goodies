package DDG::Goodie::Factorial;
# ABSTRACT: n factorial

use strict;
use DDG::Goodie;

use List::Util qw(reduce);
use bignum;
use Scalar::Util qw(looks_like_number);

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
    return if(looks_like_number($n) eq false);
    
    #check if given number is negative
    my $isNegative = 0;
    if( $n =~/^\-/ ){
        $n = $n*(-1);
        $isNegative = 1;
    }
    
    my $fact = reduce { $a * $b } 1 .. $n;
    
    #if given number is negative then
    if($isNegative){
        $fact = '-'.$fact;
        $n = '-'.$n;
    }
    
    return "Factorial of $n is $fact",
      structured_answer => {
        input     => [$n],
        operation => 'Factorial',
        result    => $fact
    };

};

1;
