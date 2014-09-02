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
    
    'what is the ultimate answer to life the universe and everything'=>
        test_zci(
<<<<<<< HEAD
            'Forty-two', html => '<span style="font-size: 1.5em;">Forty-two</span>'
=======
            'Forty-two', html => '<span style="font-size: 1.5em; fontweight: 400;">Forty-two</span>'
>>>>>>> d7f48f7099adc1623d088696ca6bfa953d57ef6a
        ),
    'what is the answer to my homework question' => undef,
    'why?' => undef,
);

done_testing;
