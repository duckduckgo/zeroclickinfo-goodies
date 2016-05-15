#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use DDG::Test::Location;
use DDG::Request;

zci answer_type => 'helpline';
zci is_cached   => 0;

my @queries = (
    'suicide',
    'suicide hotline',
    'kill myself',
    'suicidal thoughts',
    'end my life',
    'suicidal thoughts',
    'suicidal',
    'suicidal ideation',
    'i want to kill myself',
    'commit suicide',
    'suicide pills',
    'suicide pill',
    'suicide prevention',
    'kill myself',
);

my @locations = (
    'au',
    'us',
);

my @ok_queries = (
    'suicide girls',
    'suicide silence',
);

sub build_test
{
    return test_zci(re(qr/24 Hour Suicide Hotline/), structured_answer => {
        data => {
            title => re(qr/[0-9]{2}/),
            subtitle =>re(qr/24 Hour Suicide Hotline/)
        },
        templates => {
            group => 'text'
        }
    });
}

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
            build_test(),
        } 0 .. scalar @locations - 1
    } 0 .. scalar @queries - 1),
    (map {
        my $query = $ok_queries[$_];
        map {
            DDG::Request->new(
                query_raw => "$query",
                location => test_location("$locations[$_]")
            ),
            undef
        } 0 .. scalar @locations - 1
    } 0 .. scalar @ok_queries - 1),
);

done_testing;
