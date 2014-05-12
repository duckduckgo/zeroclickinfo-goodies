package DDG::Goodie::DuckDuckGo;
# ABSTRACT: Return hard-coded descriptions for DuckDuckGo terms

use DDG::Goodie;

use YAML qw( Load );

primary_example_queries 'help';
secondary_example_queries 'Zero-Click Info', 'zeroclick';
description 'DuckDuckGo help and quick links';
name 'DuckDuckGo';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DuckDuckGo.pm';
category 'cheat_sheets';
topics 'everyday';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC';

triggers startend => "duckduckgo", "ddg", "zeroclickinfo";

zci is_cached => 1;

my $responses = Load(scalar share("responses.yml")->slurp);

# The YAML is intended to be human-friendly.
# Now we make something computer-friendly.
foreach my $keyword (keys %$responses) {
    my $response = $responses->{$keyword};
    if (my $base_format = $response->{base_format}) {
        # We need to produce the output for each version.
        if (my $info_url = $response->{info_url}) {
            $response->{text} = $base_format;
            $response->{text} =~ s/[\[\]]//g;    # No internal linking.
            $response->{text} .= ': ' . $response->{info_url};    # Stick the link on the end.

            $response->{html} = $base_format;
            $response->{html} =~ s#\[#<a href='$info_url'>#;      # Insert link.
            $response->{html} =~ s#\]#</a>#;
            $response->{html} .= '.';
        } else {
            # No link to insert, so it must be ready for both.
            $response->{text} = $response->{html} = $response->{base_format};
        }
    }
    if (ref($response->{aliases}) eq 'ARRAY') {
        foreach my $alias (@{$response->{aliases}}) {
            # Assume we didn't add an alias for an existing keyword.
            $responses->{$alias} = $response;
        }
    }
    foreach my $key (keys %$response) {
        # No matter what they added, we only use the following keys for the actual response.
        delete $response->{$key} unless (grep { $key eq $_ } (qw(text html)));
    }
}

handle remainder => sub {
    s/\W+//g;
    my $key = lc;

    my $response = $responses->{$key};

    return unless ($response);
    return $response->{text}, html => $response->{html};
};

1;
