#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Test::Location;
use DDG::Request;

zci answer_type => 'helpline';

my @queries = (
    'suicide'
);

my @locations = (
    'us',
);

ddg_goodie_test(
	[qw(
		DDG::Goodie::HelpLine
	)],
    map {(
        DDG::Request->new(
            query_raw => "$queries[$_]",
            location => test_location($locations[$_])
        ),
        test_zci(qr/24 Hour Suicide Hotline: [\d\-){7}]/),
    )} 0 .. scalar @queries - 1
);

done_testing(scalar @queries * scalar @locations * 2);
