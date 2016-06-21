#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "military_rank";
zci is_cached   => 1;

my @us_army = (
    'United States Army Rank',
    structured_answer => {
        meta => {
            sourceName => 'Wikipedia',
            sourceUrl  => 'http://wikipedia.org/wiki/United_States_Army_enlisted_rank_insignia'
        },
        data => [
            {
                image => '/share/goodie/military_rank/999/no_insignia.svg',
                title => 'Private',
                altSubtitle => 'PV1',
                description => 'E-1 | OR-1',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/9/91/Army-USA-OR-02.svg',
                title => 'Private',
                altSubtitle => 'PV2',
                description => 'E-2 | OR-2',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/c/cc/Army-USA-OR-03.svg',
                title => 'Private First Class',
                altSubtitle => 'PFC',
                description => 'E-3 | OR-3',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/1/1c/Army-USA-OR-04b.svg',
                title => 'Specialist',
                altSubtitle => 'SPC',
                description => 'E-4 | OR-4',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Army-USA-OR-04a.svg',
                title => 'Corporal',
                altSubtitle => 'CPL',
                description => 'E-4 | OR-4',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/2/27/Army-USA-OR-05.svg',
                title => 'Sergeant',
                altSubtitle => 'SGT',
                description => 'E-5 | OR-5',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/0/0b/Army-USA-OR-06.svg',
                title => 'Staff Sergeant',
                altSubtitle => 'SSG',
                description => 'E-6 | OR-6',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/7/71/Army-USA-OR-07.svg',
                title => 'Sergeant First Class',
                altSubtitle => 'SFC',
                description => 'E-7 | OR-7',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Army-USA-OR-08b.svg',
                title => 'Master Sergeant',
                altSubtitle => 'MSG',
                description => 'E-8 | OR-8',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/3/3c/Army-USA-OR-08a.svg',
                title => 'First Sergeant',
                altSubtitle => '1SG',
                description => 'E-8 | OR-8',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/5/5d/Army-USA-OR-09c.svg',
                title => 'Sergeant Major',
                altSubtitle => 'SGM',
                description => 'E-9 | OR-9',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/3/31/Army-USA-OR-09b.svg',
                title => 'Command Sergeant Major',
                altSubtitle => 'CSM',
                description => 'E-9 | OR-9',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/f/f6/Army-USA-OR-09a.svg',
                title => 'Sergeant Major of the Army',
                altSubtitle => 'SMA',
                description => 'E-9 | OR-9',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/e/e3/US-Army-WO1.svg',
                title => 'Warrant Officer',
                altSubtitle => 'W01',
                description => 'W-1 | WO-1',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/d/de/US-Army-CW2.svg',
                title => 'Chief Warrant Officer',
                altSubtitle => 'CW2',
                description => 'W-2 | WO-2',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/2/2a/US-Army-CW3.svg',
                title => 'Chief Warrant Officer',
                altSubtitle => 'CW3',
                description => 'W-3 | WO-3',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/4/42/US-Army-CW4.svg',
                title => 'Chief Warrant Officer',
                altSubtitle => 'CW4',
                description => 'W-4 | WO-4',

            },
            {
                image => 'https://upload.wikimedia.org/wikipedia/commons/3/37/US-Army-CW5compare.svg',
                title => 'Chief Warrant Officer',
                altSubtitle => 'CW5',
                description => 'W-5 | WO-5',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/0/05/US-O1_insignia.svg',
                title       => 'Second Lieutenant',
                altSubtitle => '2LT',
                description    => 'O-1 | OF-1',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O2_insignia.svg',
                title       => 'First Lieutenant',
                altSubtitle => '1LT',
                description    => 'O-2 | OF-1',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O3_insignia.svg',
                title       => 'Captain',
                altSubtitle => 'CPT',
                description    => 'O-3 | OF-2',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/8/8f/US-O4_insignia.svg',
                title       => 'Major',
                altSubtitle => 'MAJ',
                description    => 'O-4 | OF-3',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6e/US-O5_insignia.svg',
                title       => 'Lieutenant Colonel',
                altSubtitle => 'LTC',
                description    => 'O-5 | OF-4',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c5/US-O6_insignia.svg',
                title       => 'Colonel',
                altSubtitle => 'COL',
                description    => 'O-6 | OF-5',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/2/23/US-O7_insignia.svg',
                title       => 'Brigadier General',
                altSubtitle => 'BG',
                description    => 'O-7 | OF-6',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/9/91/US-O8_insignia.svg',
                title       => 'Major General',
                altSubtitle => 'MG',
                description    => 'O-8 | OF-7',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/d/da/US-O9_insignia.svg',
                title       => 'Lieutenant General',
                altSubtitle => 'LG',
                description    => 'O-9 | OF-8',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/4/40/US-O10_insignia.svg',
                title       => 'General',
                altSubtitle => 'GEN',
                description    => 'O-10 | OF-9',
            },
        ],
        templates => {
            group       => 'media',
            detail      => 0,
            item_detail => 0,
            variants => { tile => 'narrow' },
            elClass  => { tileMedia => 'tile__media--pr' },
        },
    }
);
my @pl_af = (
    'Poland Air Force Rank',
    structured_answer => {
        meta => {
            sourceName => 'Wikipedia',
            sourceUrl  => 'http://en.wikipedia.org/wiki/Polish_Armed_Forces_rank_insignia'
        },
        data => [
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/6/69/Rank_insignia_of_szeregowy_of_the_Air_Force_of_Poland.svg',
                title       => 'szeregowy',
                altSubtitle => 'szer.',
                description    => 'OR-1',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/6/62/Rank_insignia_of_starszy_szeregowy_of_the_Air_Force_of_Poland.svg',
                title       => 'starszy szeregowy',
                altSubtitle => 'st.szer.',
                description    => 'OR-2',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/b/ba/Rank_insignia_of_kapral_of_the_Air_Force_of_Poland.svg',
                title       => 'kapral',
                altSubtitle => 'kpr.',
                description    => 'OR-3',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/2/22/Rank_insignia_of_starszy_kapral_of_the_Air_Force_of_Poland.svg',
                title       => 'starszy kapral',
                altSubtitle => 'st.kpr.',
                description    => 'OR-4',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/e/e9/Rank_insignia_of_plutonowy_of_the_Air_Force_of_Poland.svg',
                title       => 'plutonowy',
                altSubtitle => 'plut.',
                description    => 'OR-4',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/8/82/Rank_insignia_of_sier%C5%BCant_of_the_Air_Force_of_Poland.svg',
                title       => 'sierzant',
                altSubtitle => 'sierz.',
                description    => 'OR-5',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/b/bc/Rank_insignia_of_starszy_sier%C5%BCant_of_the_Air_Force_of_Poland.svg',
                title       => 'starszy sierzant',
                altSubtitle => 'st.sierz.',
                description    => 'OR-6',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/5/55/Rank_insignia_of_m%C5%82odszy_chor%C4%85%C5%BCy_of_the_Air_Force_of_Poland.svg',
                title       => 'mlodszy chorazy',
                altSubtitle => 'ml.chor.',
                description    => 'OR-7',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/f/f4/Rank_insignia_of_chor%C4%85%C5%BCy_of_the_Air_Force_of_Poland.svg',
                title       => 'chorazy',
                altSubtitle => 'chor.',
                description    => 'OR-8',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/d/de/Rank_insignia_of_starszy_chor%C4%85%C5%BCy_of_the_Air_Force_of_Poland.svg',
                title       => 'starszy chorazy',
                altSubtitle => 'st.chor.',
                description    => 'OR-9',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/5/56/Rank_insignia_of_starszy_chor%C4%85%C5%BCy_sztabowy_of_the_Air_Force_of_Poland.svg',
                title       => 'starszy chorazy sztabowy',
                altSubtitle => 'st.chor.szt.',
                description    => 'OR-9',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/f/fe/Rank_insignia_of_podporucznik_of_the_Air_Force_of_Poland.svg',
                title       => 'podporucznik',
                altSubtitle => 'ppor.',
                description    => 'OF-1',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c8/Rank_insignia_of_porucznik_of_the_Air_Force_of_Poland.svg',
                title       => 'porucznik',
                altSubtitle => 'por.',
                description    => 'OF-1',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/a/ad/Rank_insignia_of_kapitan_of_the_Air_Force_of_Poland.svg',
                title       => 'kapitan',
                altSubtitle => 'kpt.',
                description    => 'OF-2',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/1/1b/Rank_insignia_of_major_of_the_Air_Force_of_Poland.svg',
                title       => 'major',
                altSubtitle => 'mjr.',
                description    => 'OF-3',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/4/48/Rank_insignia_of_podpu%C5%82kownik_of_the_Air_Force_of_Poland.svg',
                title       => 'podpulkownik',
                altSubtitle => 'pplk.',
                description    => 'OF-4',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/8/80/Rank_insignia_of_pu%C5%82kownik_of_the_Air_Force_of_Poland.svg',
                title       => 'pulkownik',
                altSubtitle => 'plk.',
                description    => 'OF-5',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/5/58/Rank_insignia_of_genera%C5%82_brygady_of_the_Air_Force_of_Poland.svg',
                title       => 'general brygady',
                altSubtitle => 'gen.bryg.',
                description    => 'OF-6',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/e/e2/Rank_insignia_of_genera%C5%82_dywizji_of_the_Air_Force_of_Poland.svg',
                title       => 'general dywizji',
                altSubtitle => 'gen.dyw.',
                description    => 'OF-7',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/0/05/Rank_insignia_of_genera%C5%82_broni_of_the_Air_Force_of_Poland.svg',
                title       => 'general broni',
                altSubtitle => 'gen.broni',
                description    => 'OF-8',
            },
            {
                image       => 'https://upload.wikimedia.org/wikipedia/commons/1/17/Rank_insignia_of_genera%C5%82_of_the_Air_Force_of_Poland.svg',
                title       => 'general',
                altSubtitle => 'gen.',
                description    => 'OF-9',
            },
        ],
        templates => {
            group       => 'media',
            detail      => 0,
            item_detail => 0,
            variants => { tile => 'narrow' },
            elClass  => { tileMedia => 'tile__media--pr' },
        },
    }
);

ddg_goodie_test(
    [qw( DDG::Goodie::MilitaryRank )],

    # Country alias variations.
    'United States Army Rank' => test_zci(@us_army),
    'american army rank'      => test_zci(@us_army),
    'U.S.A. army rank'        => test_zci(@us_army),
    'us army rank'            => test_zci(@us_army),
    'poland air force rank' => test_zci(@pl_af),
    'polish air force rank' => test_zci(@pl_af),

    # Service branch variations.
    'us armed forces rank' => test_zci(@us_army),
    'us ground force rank' => test_zci(@us_army),
    'us military rank'     => test_zci(@us_army),
    'polish air forces rank' => test_zci(@pl_af),
    'polish airforce rank'   => test_zci(@pl_af),
    'polish af rank'         => test_zci(@pl_af),

    # Include option rank/grade groupings.
    'us army chief warrant officer rank' => test_zci(@us_army),
    'us army warrant rank'               => test_zci(@us_army),
    'us army enlisted rank'              => test_zci(@us_army),
    'polish air force generals rank' => test_zci(@pl_af),
    'polish air force officer rank'  => test_zci(@pl_af),

    # Keyworm "rank" variations.
    'us army rank structure' => test_zci(@us_army),
    'us army rates'          => test_zci(@us_army),
    'polish air force rank insignias' => test_zci(@pl_af),
    'polish air force symbols' => test_zci(@pl_af),

    # Queries that do not trigger MilitaryRank:
    # - Improper order.
    'rank us army' => undef,
    # - Improper spelling.
    'us militray rank' => undef,
    # - Invalid optional rank/grade.
    'us army chief ranks' => undef,
    # - Country not yet included.
    'australian army rank' => undef,
    # - Rank structure not yet included.
    'us coast guard rank' => undef,
    # - Alias for a country that exists but that alias is not included.
    'United States of America Army Rank Structure' => undef,
    # - Unrelated query that ends in keyword.
    'best credit card rates' => undef,
);

done_testing;
