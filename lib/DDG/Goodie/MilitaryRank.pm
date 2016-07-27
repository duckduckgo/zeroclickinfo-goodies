package DDG::Goodie::MilitaryRank;
# ABSTRACT: Return rank structure for a given military branch.

use DDG::Goodie;
use strict;

use YAML::XS 'LoadFile';

zci answer_type => 'military_rank';
zci is_cached   => 1;

# Get Goodie version to insert into no-insignia.svg path. Default to 999 for testing.
my $goodie_version = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

my $DATA = LoadFile(share('military_rank.yml'));

my $DISPLAY_NAME_FOR = {
    ba        => 'Bosnia and Herzegovina',
    in        => 'India',
    pl        => 'Poland',
    us        => 'United States',
    air_force => 'Air Force',
    army      => 'Army',
    marines   => 'Marine Corps',
    navy      => 'Navy',
};

my $PATTERNS = {
    countries => {
        ba => 'bosnia and herzegovina|bosnian?|bih',
        in => 'indian?',
        pl => 'poland|polish',
        us => 'united states|u\.?s\.?a?\.?|american?',
    },
    branches => {
        air_force => 'air ?forces?|af',
        army      => 'army|(?:armed|ground|land) forces?|military',
        marines   => 'marines?(?:\s+corps)?',
        navy      => 'navy',
    },
    # Note: Currently do nothing with $grade. Eventually maybe we could add a 
    # highlight to a section? Or only return one section? Or scroll the results 
    # to that rank?
    grades => {
        enlisted => 'enlisted',
        warrant  => '(?:chiefs?\s+)?warrants?(?:\s+officers?)?',
        officer  => 'officers?|generals?(?:\s+officers?)?',
    },
    keywords => [('rank', 'ranks', 'rate', 'rates', 'rank structure', 'insignia', 'insignias', 'symbols')],
};

my $country_pat = join '|', values %{$PATTERNS->{countries}};
my $branch_pat  = join '|', values %{$PATTERNS->{branches}};
my $grade_pat   = join '|', values %{$PATTERNS->{grades}};
my $keywords    = join '|', @{$PATTERNS->{keywords}};

my $complete_regex = qr/^(?:($country_pat)\s+)?($branch_pat)\s+(?:(?:$grade_pat)(?:\s+))?(?:$keywords)/i;

triggers end => @{$PATTERNS->{keywords}};

handle words => sub {
    my ($country, $branch) = $_ =~ $complete_regex;

    return unless $branch;

    # TODO: Localize this default to the country of the searcher.
    $country = 'us' unless $country; # Default $country to us. 
    $country = get_key_from_pattern_hash($PATTERNS->{countries}, $country);
    $branch  = get_key_from_pattern_hash($PATTERNS->{branches}, $branch);

    my $text_response = join ' ', ($DISPLAY_NAME_FOR->{$country}, $DISPLAY_NAME_FOR->{$branch}, 'Rank');

    my $structured_answer = $DATA->{$country}->{$branch};
    foreach my $rank (@{$structured_answer->{data}}) {
        $rank->{image} = '/share/goodie/military_rank/' . $goodie_version . '/no_insignia.svg'
            unless $rank->{image};
    }
    $structured_answer->{templates} = {
        group       => 'media',
        detail      => 0,
        item_detail => 0,
        variants => { tile => 'narrow' },
        # Scales oversize images to fit instead of clipping them.
        elClass  => { tileMedia => 'tile__media--pr' },
    };

    return $text_response, structured_answer => $structured_answer;
};

sub get_key_from_pattern_hash {
    my ($hash, $subject) = @_;
    my @keys = keys %$hash; # Reset the each %$hash iterator
    while ( my ($key, $pat) = each %$hash ) {
        return $key if $subject =~ qr/$pat/i;
    }
    return 0;
}

1;
