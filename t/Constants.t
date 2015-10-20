#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
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
            operation => 'Hardy Ramanujan Number 1729',
            result    => "1<sup>3</sup> + 12<sup>3</sup> = 9<sup>3</sup> + 10<sup>3</sup>",
        }
    ),
    #without apostrophe
    "Avogadros number" => test_zci(
        '6.0221415 × 10<sup>23</sup> mol<sup>-1</sup>',
        structured_answer => {
            input => [],
            operation => 'Avogadro\'s Number',
            result => '6.0221415 × 10<sup>23</sup> mol<sup>-1</sup>',
        }
    ),
    #with apostrophe
    "Avogadro's number" => test_zci(
        '6.0221415 × 10<sup>23</sup> mol<sup>-1</sup>',
        structured_answer => {
            input => [],
            operation => 'Avogadro\'s Number',
            result => '6.0221415 × 10<sup>23</sup> mol<sup>-1</sup>',
        }
    ),
    #constant without html (only plain)
    "Eulers constant" => test_zci(
        '0.577215665',
        structured_answer => {
            input => [],
            operation => 'Euler\'s Constant',
            result => '0.577215665',
        }
    ),
    "How old is my grandma?" => undef,
    "why?" => undef, 
);

done_testing;
