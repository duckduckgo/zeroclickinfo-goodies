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
            input     => [],
            operation => 'Zapp Brannigan quote',
            result    => qr/Zapp Brannigan: /,
        },
    ),
);

done_testing;
