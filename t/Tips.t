#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'tip';
zci is_cached => 0;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Tips
        )],
        '20% tip on $20' => test_zci('Tip: $4.00; Total: $24.00'),
        '20% tip on $20 bill' => test_zci('Tip: $4.00; Total: $24.00'),
        '20% tip for a $20 bill' => test_zci('Tip: $4.00; Total: $24.00'),
        '20 percent tip on $20' => test_zci('Tip: $4.00; Total: $24.00'),
);

done_testing;
