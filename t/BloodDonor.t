#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "blood_donor";
zci is_cached => 1;

ddg_goodie_test(
    [qw(
	DDG::Goodie::BloodDonor
    )],
	'donor A+' => test_zci(<<END
Ideal donor: A+
Other donors: A+ or 0+
Only if no Rh(+) found: A- or 0-
END
,
	html => "<table><tr><td>Ideal donor:&nbsp;&nbsp;&nbsp;</td><td>A+</td></tr><tr><td>Other donors:&nbsp;&nbsp;&nbsp;</td><td>A+ or 0+</td></tr><tr><td><b>Only if</b> no Rh(+) found:&nbsp;&nbsp;&nbsp;</td><td>A- or 0-</td></tr></table>",
	heading => "Donors for blood type A+"
		),
);

done_testing;
