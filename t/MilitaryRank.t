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
    $answer->{id} = 'military_rank';

    return $text, structured_answer => $answer;
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::MilitaryRank )],

    # Valid country alias variations and service branches.
    # - USA
    'us army rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'United States Navy Rates'
        => build_test('us', 'navy', 'United States Navy Rank'),
    'U.S.A. Marine Corps rank structure'
        => build_test('us', 'marines', 'United States Marine Corps Rank'),
    'american air force insignia'
        => build_test('us', 'air_force', 'United States Air Force Rank'),
    'america army rank'
        => build_test('us', 'army', 'United States Army Rank'),
    # - Poland
    'Poland Army Rank'
        => build_test('pl', 'army', 'Poland Army Rank'),
    'poland navy rates'
        => build_test('pl', 'navy', 'Poland Navy Rank'),
    'polish air force ranks'
        => build_test('pl', 'air_force', 'Poland Air Force Rank'),
    # - Bosnia and Herzegovina
    'bosnia military rank'
        => build_test('ba', 'army', 'Bosnia and Herzegovina Army Rank'),
    'Bosnian land forces rank insignia'
        => build_test('ba', 'army', 'Bosnia and Herzegovina Army Rank'),
    'BiH army rank'
        => build_test('ba', 'army', 'Bosnia and Herzegovina Army Rank'),
    'Bosnia and Herzegovina army symbols'
        => build_test('ba', 'army', 'Bosnia and Herzegovina Army Rank'),
    'Bosnian land forces rank insignia'
        => build_test('ba', 'army', 'Bosnia and Herzegovina Army Rank'),
    
    # Valid branch aliases.
    # - Air Force
    'us air force rank'
        => build_test('us', 'air_force', 'United States Air Force Rank'),
    'us airforce rank'
        => build_test('us', 'air_force', 'United States Air Force Rank'),
    'us air forces rank'
        => build_test('us', 'air_force', 'United States Air Force Rank'),
    'us airforces rank'
        => build_test('us', 'air_force', 'United States Air Force Rank'),
    'US AF Rank'
        => build_test('us', 'air_force', 'United States Air Force Rank'),
    # - Army
    'us army rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us armed forces rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us ground forces rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us land force rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us military rank'
        => build_test('us', 'army', 'United States Army Rank'),
    # - Marine Corps
    'us marines rank'
        => build_test('us', 'marines', 'United States Marine Corps Rank'),
    'us marine rank'
        => build_test('us', 'marines', 'United States Marine Corps Rank'),
    'us marine corps rank'
        => build_test('us', 'marines', 'United States Marine Corps Rank'),
    'us marines corps rank'
        => build_test('us', 'marines', 'United States Marine Corps Rank'),
    # - Navy
    'us navy rates'
        => build_test('us', 'navy', 'United States Navy Rank'),

    # Valid queries that include option rank/grade groupings.
    # - Enlisted
    'us army enlisted rank'
        => build_test('us', 'army', 'United States Army Rank'),
    # - Warrant. (Not all-encompassing. There are more optional 's' characters)
    'us army warrant rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us army warrants rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us army chiefs rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us army chief warrant rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us army chief warrant officer rank'
        => build_test('us', 'army', 'United States Army Rank'),
    # - Officer
    'us army officer rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us army officers rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us army general rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us army generals rank'
        => build_test('us', 'army', 'United States Army Rank'),
    'us army general officer rank'
        => build_test('us', 'army', 'United States Army Rank'),

    # Valid aliases for rank.
    'polish navy ranks'
        => build_test('pl', 'navy', 'Poland Navy Rank'),
    'polish navy rank insignias'
        => build_test('pl', 'navy', 'Poland Navy Rank'),
    'polish navy rank symbols'
        => build_test('pl', 'navy', 'Poland Navy Rank'),
    'polish navy rank structure'
        => build_test('pl', 'navy', 'Poland Navy Rank'),
    # - Insignia
    'polish navy insignia'
        => build_test('pl', 'navy', 'Poland Navy Rank'),
    # - Symbols
    'polish navy symbol'
        => build_test('pl', 'navy', 'Poland Navy Rank'),
    # - Rates
    'polish navy rates'
        => build_test('pl', 'navy', 'Poland Navy Rank'),

    # Queries that do not trigger MilitaryRank:
    # - Improper order.
    'rank us army' => undef,
    # - Improper spelling.
    'us militray rank' => undef,
    # - Country not yet included.
    'australian army rank' => undef,
    # - Rank structure not yet included.
    'us coast guard rank' => undef,
    # - Alias for a country that exists but that alias is not included.
    'United States of America Army Rank Structure' => undef,
);

done_testing;
