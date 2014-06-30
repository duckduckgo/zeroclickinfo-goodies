#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "blood_donor";

ddg_goodie_test(
    ['DDG::Goodie::BloodDonor'],
    'donor A+' => test_zci("Ideal donor: A+\nOther donors: A+ or O+\nOnly if no Rh(+) found: A- or O-\n",
        html => qr"<style.*<table class='blooddonor'>.*</table>"s,
        heading => "Donors for blood type A+"
    ),
    'donors for A+' => test_zci("Ideal donor: A+\nOther donors: A+ or O+\nOnly if no Rh(+) found: A- or O-\n",
        html => qr"<style.*<table class='blooddonor'>.*</table>"s,
        heading => "Donors for blood type A+"
        ),
    'blood donor A+' => test_zci("Ideal donor: A+\nOther donors: A+ or O+\nOnly if no Rh(+) found: A- or O-\n",
        html => qr"<style.*<table class='blooddonor'>.*</table>"s,
        heading => "Donors for blood type A+"
        ),
        'blood donors for A+' => test_zci("Ideal donor: A+\nOther donors: A+ or O+\nOnly if no Rh(+) found: A- or O-\n",
        html => qr"<style.*<table class='blooddonor'>.*</table>"s,
        heading => "Donors for blood type A+"
        ),
    'donor o+' => test_zci("Ideal donor: O+\nOther donors: O+\nOnly if no Rh(+) found: O-\n",
        html => qr"<style.*<table class='blooddonor'>.*</table>"s,
        heading => "Donors for blood type O+"
    ),
);

done_testing;
