package DDG::Goodie::SSBMData;
# ABSTRACT: This IA returns frame data for Super Smash Bros. Melee characters

use DDG::Goodie;
use strict;
use warnings;
use YAML::XS 'LoadFile';

zci answer_type => 'ssbmdata';

zci is_cached => 1;

triggers any => 'super smash bros frame data', 'super smash bros melee frame data', 'ssbm frame data', 'melee frame data', 'ssbm data', 'melee data', 'melee';

my $chars = LoadFile('share/goodie/ssbm_data/data.yml');

handle remainder => sub {

    my $remainder = $_;

    return unless $remainder;
    return unless (exists($chars->{$remainder}));
 
    my $char_data = $chars->{$remainder};
    my @moves = keys($char_data);
    
    my @record_keys = ["Jab", "Jab 2", "Rapid Jab", "Forward Tilt", "Down Tilt", "Up Tilt", "Dash Attack", "Forward Smash", "Up Smash", "Down Smash", "Neutral Air", "Up Air", "Back Air", "Down Air", "Forward Air", "Grab", "Dash Grab", "Down B", "Neutral B", "Side B", "Up B", "Air Dodge", "Spot Dodge", "Roll", "Jump", "Aerial Neutral B", "Gentleman", "Aerial Side B", "Aerial Up B", "Jab 3", "Aerial Down B", "Forward Smash 2", "Taunt", "Backward Roll", "Up B Launch", "Aerial Side B", "Air Grapple", "Hard Side B", "Aerial Up B"];

    return 'plain text response',
        structured_answer => {

            data => {
                title       => "Melee Active Frames",
                subtitle    => ucfirst $remainder,
                record_data => $char_data,
                record_keys => @record_keys
            },

            templates => {
                group   => 'list',
                options => {
                    content      => 'record',
                    rowHighlight => 1
                }
            }
            
        };
};

1;
