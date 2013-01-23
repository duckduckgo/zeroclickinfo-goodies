use strict;

use DDG::Test::Goodie;

zci answer_type => 'fibonacci';
zci is_cached => 1;

ddg_goodie_test(
        [qw(DDG::Goodie::Fibonacci)],
        'fib 7' => test_zci('fib(7) = 13 with f(0) = 0'),
        'fibonacci 33' => test_zci('fib(33) = 3524578 with f(0) = 0'), 
);

done_testing;
