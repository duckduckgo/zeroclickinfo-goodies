#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Test::Location;
use DDG::Request;

zci answer_type => 'helpline';

my @queries = (
    'suicide',
    'suicidal thoughts',
    'i want to commit suicide',
    'i want to end my life',
);

my @skip_queries = (
    'suicidal thoughts lyrics',
);

my @locations = (
    'us',
);

ddg_goodie_test(
	[qw(
		DDG::Goodie::HelpLine
	)],
    (map {
        my $query = $queries[$_];
        map {
            DDG::Request->new(
                query_raw => "$query",
                location => test_location("$locations[$_]")
            ),
            test_zci(qr/24 Hour Suicide Hotline: [\d\-){7}]/),
        } 0 .. scalar @locations - 1
    } 0 .. scalar @queries - 1),
    (map {
        my $query = $skip_queries[$_];
        map {
            DDG::Request->new(
                query_raw => "$query",
                location => test_location("$locations[$_]")
            ),
            undef
        } 0 .. scalar @locations - 1
    } 0 .. scalar @skip_queries - 1),
);

done_testing(
    (scalar @queries * scalar @locations * 2) +
    (scalar @skip_queries * scalar @locations)
);
