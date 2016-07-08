package DDG::Goodie::ColorPicker;
# ABSTRACT: Presents a color picker that allows the user to select a color or build a color palette.

use DDG::Goodie;
use strict;
use warnings;
use Color::Library;

zci answer_type => 'color_picker';

zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers start => ['color picker', 'colour picker', 'colorpicker', 'colourpicker', 'manrajtest'];
my $goodie_version = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

# Handle statement
handle remainder => sub {
    my $color = $_;
    my $remainder = $_;
    print $remainder;
    my $path = "/share/goodie/color_picker/$goodie_version/";
    return "Color Picker",
        structured_answer => {
            id => 'color_picker',
            name => 'Color Picker',
            data => {
                color => $color,
                saturation_value_path => $path.'saturation_value_gradient.png',
                hue_path => $path.'hue_gradient.png'
            },
            templates => {
                group => 'text'
            }
        };
};

1;
