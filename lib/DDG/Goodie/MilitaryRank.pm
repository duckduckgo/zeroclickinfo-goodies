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
    # TODO: Would love to apply class "tile__media--pr" alongside the "tile__media"
    # class to shrink oversize images instead of clipping oversize images.
    $structured_answer->{templates} = { group => 'media' };
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
