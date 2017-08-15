package DDG::Goodie::WhatDoesDaxSay;
# ABSTRACT: Dax is the DuckDuckGo mascot and this is what he says.

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'what_does_dax_say';

zci is_cached => 1;

triggers start => 'what does dax say', 'what does the dax say';

# Get Goodie version for use with image paths
my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

handle remainder => sub {
    return '',
        structured_answer => {
            id => "what_does_dax_say",
            data => {
                goodie_version => $goodieVersion
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.what_does_dax_say.content'
                }
            }
        };
};

1;
