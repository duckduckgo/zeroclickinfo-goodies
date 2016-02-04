package DDG::Goodie::IAHints;

# ABSTRACT: Write an abstract here

use DDG::Goodie;
use strict;

zci answer_type => 'iahints';

zci is_cached => 1;

my %iahints = (
    'news' => 'obama news',
    'air quality' => 'air quality 33434',
    '(iphone|ipad|android) apps' => 'productivity apps',
    'gifs?' => 'cat gifs',
    '(english)? dictionary' => 'define obsequious'
);

my $re = '^('.join('|', keys(%iahints)).')$';

triggers query_lc => qr/$re/;

# Handle statement
handle matches => sub {

    my $suggestion = %iahints->{$_};

    return unless $suggestion;

    return "",
        structured_answer => {

            id => 'iahints',

            name => 'Answer',

            data => {
              subtitle => "Why not try $suggestion?"
            },

            templates => {
                group => "text",
                # options => {
                #
                # }
            }
        };
};

1;
