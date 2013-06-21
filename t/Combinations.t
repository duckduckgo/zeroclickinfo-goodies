use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'combination';
zci is_cached => 1;

ddg_goodie_test(
    [
        'DDG::Goodie::Combinations'
    ], 

    ' 5 choose 3' => test_zci('5 choose 3 = 10'),
    '5 choose 3 ' => test_zci('5 choose 3 = 10'),
    ' 5 choose 3 ' => test_zci('5 choose 3 = 10'),
    '7 choose 0' => test_zci('7 choose 0 = 1'),
    '0 choose 3' => test_zci('0 choose 3 = 0'),
    "-1 choose -2" =
>);

done_testing;