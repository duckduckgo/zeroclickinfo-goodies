#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'valarmorghulis';

ddg_goodie_test(
    [
        'DDG::Goodie::ValarMorghulis'
    ],
    'valar morghulis' =>
        test_zci(
            'Valar dohaeris',
            html => '<span style="font-size: 1.5em; font-weight: 400;">Valar dohaeris</span>'
        ),
    'what is valar morghulis' => undef,
    'valar morghulis meaning' => undef,  
);

done_testing;
