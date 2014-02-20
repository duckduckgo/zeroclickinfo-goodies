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
	   'gcf 9 81' => test_zci('Greatest common factor of 9 and 81 is 9.', html => 'Greatest common factor of 9 and 81 is 9. More at <a href="https://en.wikipedia.org/wiki/Greatest_common_factor">Wikipedia</a>.'),
	   '1000 100 greatest common factor' => test_zci ('Greatest common factor of 1000 and 100 is 100.', html => 'Greatest common factor of 1000 and 100 is 100. More at <a href="https://en.wikipedia.org/wiki/Greatest_common_factor">Wikipedia</a>.'),
	   'GCF 12 76' => test_zci('Greatest common factor of 12 and 76 is 4.', html => 'Greatest common factor of 12 and 76 is 4. More at <a href="https://en.wikipedia.org/wiki/Greatest_common_factor">Wikipedia</a>.'),
    'GCF 121 11' => test_zci('Greatest common factor of 121 and 11 is 11.', html => 'Greatest common factor of 121 and 11 is 11. More at <a href="https://en.wikipedia.org/wiki/Greatest_common_factor">Wikipedia</a>.'),
    '99 9 greatest common factor' => test_zci('Greatest common factor of 99 and 9 is 9.', html => 'Greatest common factor of 99 and 9 is 9. More at <a href="https://en.wikipedia.org/wiki/Greatest_common_factor">Wikipedia</a>.'),
);

done_testing;
