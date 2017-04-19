package DDG::Goodie::Factorial;
# ABSTRACT: Calculate foctorial of a number
# https://duck.co/ia/view/factorial_calculator

use DDG::Goodie;
use strict;

zci answer_type => 'factorial';

zci is_cached => 1;

triggers start => 'factorial of', 'factorial';

sub factorial_calc{
    my $n = $_;
    my $f = 1;
    while ($n > 0){
        $f = $f*$n;
        $n = $n-1;
    }
    return $f;
}

# Handle statement
handle remainder => sub {
    
    return unless $_;

    my $factorial_output = factorial_calc($_);

    return "Factorial is $factorial_output",
        structured_answer => {

            data => {
                title    => "$factorial_output",
                subtitle => "Factorial: $_",
            },

            templates => {
                group => "text",
            }
        };
};

1;
