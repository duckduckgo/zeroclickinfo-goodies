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
    DDG::Request->new(
        query_raw => "$queries[0]",
        location => test_location($locations[0])
    ),
	test_zci(qr/24 Hour Suicide Hotline: [\d\-){7}]/),
);

done_testing;

