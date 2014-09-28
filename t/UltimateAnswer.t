#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => "UltimateAnswer";

ddg_goodie_test(
    [
        'DDG::Goodie::UltimateAnswer'
    ],
    
    'what is the answer to the ultimate question of life the universe and everything'=>
        test_zci(
            'Forty-two', html => '<span class="zci--ultanswer">Forty-two</span>'
        ),
    'what is the answer to my homework question' => undef,
    'why?' => undef,
);

done_testing;
