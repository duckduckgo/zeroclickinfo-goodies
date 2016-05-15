#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use DDG::Goodie::MilitaryRank;

zci answer_type => "military_rank";
zci is_cached   => 1;

sub build_structured_answer {
    my ($country, $branch, $text) = @_;

    # Use DATA() sub from module because we simply want to test that
    # the query returns the proper data. We do not test each bit of data
    # for correctness. Rely on the module to be correct in that sense.
    my $answer = DDG::Goodie::MilitaryRank::DATA()->{$country}->{$branch};
    $answer->{templates} = {
        group       => 'media',
        detail      => 'false',
        item_detail => 'false',
        variants => { tile => 'narrow' },
        elClass  => { tileMedia => 'tile__media--pr' },
    };

    return $text, structured_answer => { $answer };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::MilitaryRank )],
    # Valid queries
    'us army rank' => build_test('us', 'army', 'United States Army Rank');

    # Queries do not trigger MilitaryRank
    # - Improperly ordered
    # - Improperly spelled
    # - Ranks not yet included
    'bad example query' => undef,
);

done_testing;
