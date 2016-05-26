package DDG::Goodie::DuckDuckGo;
# ABSTRACT: Return hard-coded descriptions for DuckDuckGo terms

use strict;
use DDG::Goodie;

use YAML::XS 'LoadFile';

my @ddg_aliases = map { ("${_}'s", "${_}s", $_) } ('duck duck go', 'duckduck go', 'duck duckgo', 'duckduckgo', 'ddg');
my @any_triggers = (@ddg_aliases, "zeroclickinfo", "private search", "whois");

triggers any => @any_triggers;

zci is_cached => 1;

my $trigger_qr = join('|', map { quotemeta } @any_triggers);
$trigger_qr = qr/\b(?:$trigger_qr)\b/i;
#warn $trigger_qr;

my $responses = LoadFile(share('responses.yml'));

# The YAML is intended to be human-friendly.
# Now we make something computer-friendly.
foreach my $keyword (keys %$responses) {
    my $response = $responses->{$keyword};

    # Setup basic response.
    if ($response->{title}) {
        $response->{text} = $response->{title};
        if ($response->{url}) {
            $response->{text} .= ' '.$response->{url};
        }
    } else {
        $response->{text} = '';
    }

    # If there's no subtitle, make the subtitle the url text.
    unless ($response->{subtitle}) {
        $response->{subtitle} = $response->{url};
    }

    # Setup aliases.
    if (ref($response->{aliases}) eq 'ARRAY') {
        foreach my $alias (@{$response->{aliases}}) {
            # Assume we didn't add an alias for an existing keyword.
            $responses->{$alias} = $response;
        }
    }
}

my $skip_words_re = qr/\b(?:what|where|is|of|for|the|in|on)\b/;

handle query_raw => sub {
    my $key = lc;

    my ($trigger) = $key =~ /($trigger_qr)/;

    $key =~ s/\b$trigger\b//g;   # Strip trigger on word boundaries.
    $key =~ s/\?//g;             # Allow for questions, but don't pollute skip words.
    $key =~ s/$skip_words_re//g; # Strip skip words.
    $key =~ s/\W+//g;            # Strip all non-word characters.

    #warn "Query: '$_'\tTrigger: '$trigger'\tMajor Key: '$key'";

    # Whois escape hatch for invalid keys.
    if ($trigger eq 'whois') {
        return if $key ne 'duckduckgoownedserveryahoonet';
        $key = 'yahoo';
    }

    my $response = $responses->{$key};
    return unless $response;

    return $response->{text},
    structured_answer => {
        data => {
            title => $response->{title},
            subtitle_image => $response->{image},
            subtitle_text => $response->{subtitle},
            subtitle_url => $response->{url}
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.duck_duck_go.subtitle_content'
            }
        }
    };
};

1;
