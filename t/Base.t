#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'conversion';
zci is_cached => 1;

ddg_goodie_test(
        [qw(
                DDG::Goodie::Base
        )],

        '255 in hex'                      => test_zci('255 in base 16 is FF'),
        '255 in base 16'                  => test_zci('255 in base 16 is FF'),
        '42 in binary'                    => test_zci('42 in base 2 is 101010'),
        '42 in base 2'                    => test_zci('42 in base 2 is 101010'),
        '42 to hex',                      => test_zci('42 in base 16 is 2A'),
        '10 in base 3'                    => test_zci('10 in base 3 is 101'),
        '18442240474082181119 to hex'     => test_zci('18442240474082181119 in base 16 is FFEFFFFFFFFFFFFF'),
        '999999999999999999999999 to hex' => test_zci('999999999999999999999999 in base 16 is D3C21BCECCEDA0FFFFFF')
        
);

done_testing;

