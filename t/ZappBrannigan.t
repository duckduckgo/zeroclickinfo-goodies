#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 0;
zci answer_type => 'zappbrannigan';

ddg_goodie_test(
        [qw(
                DDG::Goodie::ZappBrannigan
        )],
        'zapp brannigan quote' => test_zci(qr/^Captain Zapp Brannigan: /),
);

done_testing;
