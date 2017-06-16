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

    return 'plain text response',
        structured_answer => {

            data => {
                title       => "Melee Active Frames",
                subtitle    => ucfirst $remainder,
                record_data => $char_data
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
