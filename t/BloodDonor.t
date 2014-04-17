#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "blood_donor";

ddg_goodie_test(
    [qw(
	DDG::Goodie::BloodDonor
    )],
	'donor A+' => test_zci(<<END
Ideal donor: A+
Other donors: A+ or O+
Only if no Rh(+) found: A- or O-
END
,
	html => "<table><tr><td>Ideal donor:</td><td>A+</td></tr><tr><td>Other donors:</td><td>A+ or O+</td></tr><tr><td><i>Only if</i> no Rh(+) found:</td><td>A- or O-</td></tr></table>",
	heading => "Donors for blood type A+"
		),
	'donors for A+' => test_zci(<<END
Ideal donor: A+
Other donors: A+ or O+
Only if no Rh(+) found: A- or O-
END
,
	html => "<table><tr><td>Ideal donor:</td><td>A+</td></tr><tr><td>Other donors:</td><td>A+ or O+</td></tr><tr><td><i>Only if</i> no Rh(+) found:</td><td>A- or O-</td></tr></table>",
	heading => "Donors for blood type A+"
		),
	'blood donor A+' => test_zci(<<END
Ideal donor: A+
Other donors: A+ or O+
Only if no Rh(+) found: A- or O-
END
,
	html => "<table><tr><td>Ideal donor:</td><td>A+</td></tr><tr><td>Other donors:</td><td>A+ or O+</td></tr><tr><td><i>Only if</i> no Rh(+) found:</td><td>A- or O-</td></tr></table>",
	heading => "Donors for blood type A+"
		),
	'blood donors for A+' => test_zci(<<END
Ideal donor: A+
Other donors: A+ or O+
Only if no Rh(+) found: A- or O-
END
,
	html => "<table><tr><td>Ideal donor:</td><td>A+</td></tr><tr><td>Other donors:</td><td>A+ or O+</td></tr><tr><td><i>Only if</i> no Rh(+) found:</td><td>A- or O-</td></tr></table>",
	heading => "Donors for blood type A+"
		),
	'donor o+' => test_zci("Ideal donor: o+\nOther donors: O+\nOnly if no Rh(+) found: O-\n",
		html => "<table><tr><td>Ideal donor:</td><td>o+</td></tr><tr><td>Other donors:</td><td>O+</td></tr><tr><td><i>Only if</i> no Rh(+) found:</td><td>O-</td></tr></table>",
		heading => "Donors for blood type o+"
	),
);

done_testing;
