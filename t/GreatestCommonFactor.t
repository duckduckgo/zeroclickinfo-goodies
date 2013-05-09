#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "greatest_common_factor";
zci is_cached => 1;

ddg_goodie_test(
    [qw(
       	   DDG::Goodie::GreatestCommonFactor
    )],
	   'gcf 9 81' => test_zci('<a href="https://en.wikipedia.org/wiki/Greatest_common_factor">Greatest common factor</a> of 9 and 81 is 9.'),
	   '1000 100 greatest common factor' => test_zci('<a href="https://en.wikipedia.org/wiki/Greatest_common_factor">Greatest common factor</a> of 1000 and 100 is 100.'),
	   'GCF 12 76' => test_zci('<a href="https://en.wikipedia.org/wiki/Greatest_common_factor">Greatest common factor</a> of 12 and 76 is 4.'),
);

done_testing;
