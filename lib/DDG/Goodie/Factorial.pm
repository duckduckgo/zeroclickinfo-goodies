package DDG::Goodie::Factorial;
# ABSTRACT: n factorial

use strict;
use DDG::Goodie;

use List::Util qw(reduce);
use bigint;

zci answer_type => "factorial";
zci is_cached   => 1;

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
