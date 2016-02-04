package DDG::Goodie::IaHints;

# ABSTRACT: Write an abstract here

use DDG::Goodie;
use strict;

zci answer_type => 'ia_hints';

zci is_cached => 1;

# define a regex that matches for each query hint
my %iahints = (
    'news' => 'obama news',
    'air quality' => 'air quality 33434',
    '(iphone|ipad|android) apps' => 'productivity apps',
    'gifs?' => 'cat gifs',
    '(english )?dictionary' => 'define obsequious'
);

# join them into a massive regex that we use for triggers
my $re = '^('.join('|', keys(%iahints)).')$';

triggers query_lc => qr/$re/;

# Handle statement
handle matches => sub {
    my $match = $_;
    my $suggestion;

    # check which of the regexes we matched to get the query hint
    while (my ($key, $val) = each %iahints) {
        if ($match =~ /$key/) {
            $suggestion = $val;
        }
    }

    return unless $suggestion;

    return "See what happens when you search for \"$suggestion\"",
        structured_answer => {

            id => 'ia_hints',

            name => 'Productivity',

            data => {
                sample_query => $suggestion
            },

            templates => {
                group => "text",
                options => {
                    title_content => "DDH.ia_hints.title"
                }
            }
        };
};

1;
