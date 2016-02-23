package DDG::Goodie::DuckDuckGo;
# ABSTRACT: Return hard-coded descriptions for DuckDuckGo terms

use strict;
use DDG::Goodie;

use YAML::XS 'LoadFile';

my @ddg_aliases = map { ($_, $_ . "'s", $_ . "s") } ('duck duck go', 'duckduck go', 'duck duckgo', 'duckduckgo', 'ddg');

triggers any => @ddg_aliases, "zeroclickinfo", "private search";

zci is_cached => 1;

my $responses = LoadFile(share('responses.yml'));

# The YAML is intended to be human-friendly.
# Now we make something computer-friendly.
foreach my $keyword (keys %$responses) {
    my $response = $responses->{$keyword};

    if ($response->{title}) {
        $response->{text} = $response->{title};
        if ($response->{url}) {
            $response->{text} .= ' '.$response->{url};
        }
    } else {
        $response->{text} = '';
    }

    # if there's no subtitle, make the subtitle the url text:
    unless ($response->{subtitle}) {
        $response->{subtitle} = $response->{url};
    }

    if (ref($response->{aliases}) eq 'ARRAY') {
        foreach my $alias (@{$response->{aliases}}) {
            # Assume we didn't add an alias for an existing keyword.
            $responses->{$alias} = $response;
        }
    }
}

my $skip_words_re = qr/\b(?:what|where|is|of|for|the|in|on)\b/;

handle remainder => sub {
    my $key = lc;

    $key =~ s/\?//g;    # Allow for questions, but don't pollute skip words.
    $key =~ s/$skip_words_re//g;
    $key =~ s/\W+//g;

    my $response = $responses->{$key};

    return unless ($response);

    return $response->{text},
    structured_answer => {
        id => 'duck_duck_go',
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
