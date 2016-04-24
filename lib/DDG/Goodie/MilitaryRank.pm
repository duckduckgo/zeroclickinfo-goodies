package DDG::Goodie::MilitaryRank;
# ABSTRACT: Return rank structure for a given military branch.

use DDG::Goodie;
use strict;

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
                    subtitle => 'PV1',
                    altSubtitle => 'E-1 | OR-1',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-02.svg',
                    title => 'Private',
                    subtitle => 'PV2',
                    altSubtitle => 'E-2 | OR-2',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-03.svg',
                    title => 'Private First Class',
                    subtitle => 'PFC',
                    altSubtitle => 'E-3 | OR-3',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-04b.svg',
                    title => 'Specialist',
                    subtitle => 'SPC',
                    altSubtitle => 'E-4 | OR-4',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-04a.svg',
                    title => 'Corporal',
                    subtitle => 'CPL',
                    altSubtitle => 'E-4 | OR-4',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-05.svg',
                    title => 'Sergeant',
                    subtitle => 'SGT',
                    altSubtitle => 'E-5 | OR-5',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-06.svg',
                    title => 'Staff Sergeant',
                    subtitle => 'SSG',
                    altSubtitle => 'E-6 | OR-6',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-07.svg',
                    title => 'Sergeant First Class',
                    subtitle => 'SFC',
                    altSubtitle => 'E-7 | OR-7',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-08b.svg',
                    title => 'Master Sergeant',
                    subtitle => 'MSG',
                    altSubtitle => 'E-8 | OR-8',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-08a.svg',
                    title => 'First Sergeant',
                    subtitle => '1SG',
                    altSubtitle => 'E-8 | OR-8',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-09c.svg',
                    title => 'Sergeant Major',
                    subtitle => 'SGM',
                    altSubtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-09b.svg',
                    title => 'Command Sergeant Major',
                    subtitle => 'CSM',
                    altSubtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-09a.svg',
                    title => 'Sergeant Major of the Army',
                    subtitle => 'SMA',
                    altSubtitle => 'E-9 | OR-9',

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

triggers any => $complete_regex;

handle query_clean => sub {
    my ($country, $branch) = $_ =~ $complete_regex;

    # TODO: Localize this default to the country of the searcher.
    $country = 'us' unless $country; # Default $country to us. 
    $country = get_key_from_pattern_hash($PATTERNS->{countries}, $country);

    $branch = get_key_from_pattern_hash($PATTERNS->{branches}, $branch);

    my $text_response = join ' ', ($DISPLAY_NAME_FOR->{$country}, $DISPLAY_NAME_FOR->{$branch}, 'Rank');

    return $text_response,
        structured_answer => {
            templates => {
                group => 'icon'
            },
            $DATA->{$country}->{$branch}
        };
};

sub get_key_from_pattern_hash {
    my ($hash, $subject) = @_;
    while ( my ($key, $pat) = each %$hash ) {
        return $key if $subject =~ qr/$pat/i;
    }
    return 0;
}

1;
