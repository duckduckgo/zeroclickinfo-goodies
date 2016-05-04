package DDG::Goodie::VolumeOf;
# ABSTRACT: Write an abstract here

use DDG::Goodie;
use strict;

zci answer_type => 'volume_of';

zci is_cached => 1;

triggers any => 'volume of', 'volume', 'volume of a';

# Declaring Volume Lookup Hash
# Must be in LaTex
my %volumes;
$volumes{'cube'} = "s^3";
$volumes{'rectangular prism'} = "lwh";
$volumes{'rectangular solid'} = "lwh";
$volumes{'sphere'} = "\\frac{4}{3} \\pi r^3";
$volumes{'cylinder'} = "\\pi r^2h";
$volumes{'cone'} = "\\frac{1}{3} \\pi r^2h";
$volumes{'square pyramid'} = "\\frac{1}{3} s^2h";
$volumes{'triangular pyramid'} = "\\frac{1}{3} (\\frac{1}{2} b h_1)h_2"; 
$volumes{'triangular-based pyramid'} = "\\frac{1}{3} (\\frac{1}{2} b h_1)h_2"; 
$volumes{'triangular based pyramid'} = "\\frac{1}{3} (\\frac{1}{2} b h_1)h_2"; 
$volumes{'pyramid'} = "\\frac{lwh}{3}";
$volumes{'triangular prism'} = "\\frac{1}{4} h \\sqrt{-a^4 +2(ab)^2 +2(ac)^2 - b^4 + 2(bc)^2 - c^4}";

handle remainder => sub {

    my $remainder = $_;

    return unless $remainder;
    
    # Return if there is no volume available for the shape
    return unless (exists $volumes{lc($remainder)});

    $remainder = lc($remainder);
    
    return "plain text response",
        structured_answer => {
            id => "volume_of",
            name => "Answer",
            data => {
                title    => "Volume Of A " . ucfirst($remainder),
                answer => "V = " . $volumes{$remainder}
            },

            templates => {
                group => "text",
                options => {
                    subtitle_content => 'DDH.volume_of.subtitle'
                }
            }
        };
};

1;
