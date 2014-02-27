#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'whereami';
zci is_cached => 0;

ddg_goodie_test(
	[qw(DDG::Goodie::WhereAmI)],
        'where am I?' => test_zci(qr/^You appear to be in [A-Z]\w+, .+\(Lat: -?\d+\.\d+, Lon: -?\d+\.\d+\)\./, html => qr{^You appear to be in [A-Z]\w+,}),
        'my location' => test_zci(qr/^You appear to be in [A-Z]\w+, .+\(Lat: -?\d+\.\d+, Lon: -?\d+\.\d+\)\./, html => qr{^You appear to be in [A-Z]\w+,}),
        'my location is nowhere!' => undef,
);

done_testing;
