package DDG::Goodie::MilitaryRank;
# ABSTRACT: Return rank structure for a given military branch.

use DDG::Goodie;
use strict;

use Data::Dumper;
use feature qw(say);

zci answer_type => 'military_rank';
zci is_cached   => 1;

my $DATA = {
    us => {
        air_force => {

        },
        army => {
            meta => {
                sourceName => "Wikipedia",
                sourceUrl => 'http://wikipedia.org/wiki/United_States_Army_enlisted_rank_insignia'
            },
            data => [
                {
                    image => '',
                    title => 'Private',
                    altSubtitle => 'PV1',
                    subtitle => 'E-1 | OR-1',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/9/91/Army-USA-OR-02.svg',
                    title => 'Private',
                    altSubtitle => 'PV2',
                    subtitle => 'E-2 | OR-2',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/c/cc/Army-USA-OR-03.svg',
                    title => 'Private First Class',
                    altSubtitle => 'PFC',
                    subtitle => 'E-3 | OR-3',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/1/1c/Army-USA-OR-04b.svg',
                    title => 'Specialist',
                    altSubtitle => 'SPC',
                    subtitle => 'E-4 | OR-4',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/a/a2/Army-USA-OR-04a.svg',
                    title => 'Corporal',
                    altSubtitle => 'CPL',
                    subtitle => 'E-4 | OR-4',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/2/27/Army-USA-OR-05.svg',
                    title => 'Sergeant',
                    altSubtitle => 'SGT',
                    subtitle => 'E-5 | OR-5',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/0/0b/Army-USA-OR-06.svg',
                    title => 'Staff Sergeant',
                    altSubtitle => 'SSG',
                    subtitle => 'E-6 | OR-6',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/7/71/Army-USA-OR-07.svg',
                    title => 'Sergeant First Class',
                    altSubtitle => 'SFC',
                    subtitle => 'E-7 | OR-7',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/8/8a/Army-USA-OR-08b.svg',
                    title => 'Master Sergeant',
                    altSubtitle => 'MSG',
                    subtitle => 'E-8 | OR-8',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/3/3c/Army-USA-OR-08a.svg',
                    title => 'First Sergeant',
                    altSubtitle => '1SG',
                    subtitle => 'E-8 | OR-8',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/5/5d/Army-USA-OR-09c.svg',
                    title => 'Sergeant Major',
                    altSubtitle => 'SGM',
                    subtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/3/31/Army-USA-OR-09b.svg',
                    title => 'Command Sergeant Major',
                    altSubtitle => 'CSM',
                    subtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/f/f6/Army-USA-OR-09a.svg',
                    title => 'Sergeant Major of the Army',
                    altSubtitle => 'SMA',
                    subtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/e/e3/US-Army-WO1.svg',
                    title => 'Warrant Officer',
                    altSubtitle => 'W01',
                    subtitle => 'W-1 | WO1',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/d/de/US-Army-CW2.svg',
                    title => 'Chief Warrant Officer',
                    altSubtitle => 'CW2',
                    subtitle => 'W-2 | WO2',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/2/2a/US-Army-CW3.svg',
                    title => 'Chief Warrant Officer',
                    altSubtitle => 'CW3',
                    subtitle => 'W-3 | WO3',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/4/42/US-Army-CW4.svg',
                    title => 'Chief Warrant Officer',
                    altSubtitle => 'CW4',
                    subtitle => 'W-4 | WO4',

                },
                {
                    image => 'https://upload.wikimedia.org/wikipedia/commons/3/37/US-Army-CW5compare.svg',
                    title => 'Chief Warrant Officer',
                    altSubtitle => 'CW5',
                    subtitle => 'W-5 | WO5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/0/05/US-O1_insignia.svg',
                    title       => 'Second Lieutenant',
                    altSubtitle => '2LT',
                    subtitle    => 'O-1 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O2_insignia.svg',
                    title       => 'First Lieutenant',
                    altSubtitle => '1LT',
                    subtitle    => 'O-2 | OF-1',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/7/72/US-O3_insignia.svg',
                    title       => 'Captain',
                    altSubtitle => 'CPT',
                    subtitle    => 'O-3 | OF-2',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/8/8f/US-O4_insignia.svg',
                    title       => 'Major',
                    altSubtitle => 'MAJ',
                    subtitle    => 'O-4 | OF-3',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/6/6e/US-O5_insignia.svg',
                    title       => 'Lieutenant Colonel',
                    altSubtitle => 'LTC',
                    subtitle    => 'O-5 | OF-4',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/c/c5/US-O6_insignia.svg',
                    title       => 'Colonel',
                    altSubtitle => 'COL',
                    subtitle    => 'O-6 | OF-5',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/2/23/US-O7_insignia.svg',
                    title       => 'Brigadier General',
                    altSubtitle => 'BG',
                    subtitle    => 'O-7 | OF-6',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/9/91/US-O8_insignia.svg',
                    title       => 'Major General',
                    altSubtitle => 'MG',
                    subtitle    => 'O-8 | OF-7',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/d/da/US-O9_insignia.svg',
                    title       => 'Lieutenant General',
                    altSubtitle => 'LG',
                    subtitle    => 'O-9 | OF-8',
                },
                {
                    image       => 'https://upload.wikimedia.org/wikipedia/commons/4/40/US-O10_insignia.svg',
                    title       => 'General',
                    altSubtitle => 'GEN',
                    subtitle    => 'O-10 | OF-9',
                },
            ],
        },
        marines => {

        },
        navy => {

        },
    },
    # TODO: Add other countries.
};

my $DISPLAY_NAME_FOR = {
    us        => 'United States',
    air_force => 'Air Force',
    army      => 'Army',
    marines   => 'Marine Corps',
    navy      => 'Navy',
};

my $PATTERNS = {
    countries => {
        us => 'united states|u\.?s\.?a?\.?',
        # TODO: Add other countries,
    },
    branches => {
        air_force => 'air ?force|af',
        army      => 'army',
        marines   => 'marines?(?:\s+corps)?',
        navy      => 'navy',
    },
    # Note: Currently do nothing with $grade. Eventually maybe we could add a highlight to a section? Or only return one section? Or scroll the results to that rank?
    grades => {
        enlisted => 'enlisted',
        warrant  => '(?:chiefs?\s+)?warrants?(?:\s+officers?)?',
        officer  => 'officers?|generals?(?:\s+officers?)?',
    },
};

my $country_pat = join '|', values %{$PATTERNS->{countries}};
my $branch_pat  = join '|', values %{$PATTERNS->{branches}};
my $grade_pat   = join '|', values %{$PATTERNS->{grades}};
my $keywords    = 'ranks?(?:\s+insignias?)?(?:\s+symbols?)?(?:\s+structure)?|insignias?|symbols?';

my $complete_regex = qr/(?:($country_pat)\s+)?($branch_pat)\s+(?:$grade_pat\s+)?(?:$keywords)/i;

triggers query_clean => $complete_regex;

handle words => sub {
    my ($country, $branch) = $_ =~ $complete_regex;

    # TODO: Localize this default to the country of the searcher.
    $country = 'us' unless $country; # Default $country to us. 
    $country = get_key_from_pattern_hash($PATTERNS->{countries}, $country);

    $branch = get_key_from_pattern_hash($PATTERNS->{branches}, $branch);

    my $text_response = join ' ', ($DISPLAY_NAME_FOR->{$country}, $DISPLAY_NAME_FOR->{$branch}, 'Rank');

    my $structured_answer = $DATA->{$country}->{$branch};
    $structured_answer->{templates} = {
        group       => 'media',
        detail      => 'false',
        item_detail => 'false',
        variants => { tile => 'narrow' },
        # Scales oversize images to fit instead of clipping them.
        elClass  => { tileMedia => 'tile__media--pr' },
    };
    # To protect against "Use of uninitialized value in concatenation (.)
    # or string at .../App/DuckPAN/Web.pm line 447."
    $structured_answer->{id} = 'military_rank';

    return $text_response, structured_answer => $structured_answer;
};

sub get_key_from_pattern_hash {
    my ($hash, $subject) = @_;
    while ( my ($key, $pat) = each %$hash ) {
        return $key if $subject =~ qr/$pat/i;
    }
    return 0;
}

1;
