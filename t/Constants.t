#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "constants";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Constants )],
    "Hardy Ramanujan number" => test_zci(
       '1<sup>3</sup> + 12<sup>3</sup> = 9<sup>3</sup> + 10<sup>3</sup>',
        structured_answer => {
            input     => [],
            operation => 'Constants',
            result    => "1<sup>3</sup> + 12<sup>3</sup> = 9<sup>3</sup> + 10<sup>3</sup>",
        }
    ),
    "How old is my grandma?" => undef,
    "why?" => undef, 
);

done_testing;
