#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'zapp_brannigan';
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::ZappBrannigan )],
    'zapp brannigan quote' => test_zci(
        qr/Zapp Brannigan: /,
        structured_answer => {
            data => '-ANY-',
            templates => {
                group => "text",
                options => {
                    content => 'DDH.zapp_brannigan.content'
                }
            }  
        },
    ),
);

done_testing;