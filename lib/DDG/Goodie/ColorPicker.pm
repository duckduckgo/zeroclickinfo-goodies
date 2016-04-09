package DDG::Goodie::ColorPicker;
# ABSTRACT: Presents a color picker that allows the user to select a color or build a color palette.

use DDG::Goodie;
use strict;

zci answer_type => 'color_picker';
zci is_cached => 1;
# zci caller => 'DDG::Spice::ColorPicker';

triggers start => ['color picker', 'colour picker', 'colorpicker', 'colourpicker'];

handle remainder => sub {
    return "",
        structured_answer => {
            id => 'color_picker',
            name => 'Color Picker',
            signal => 'high',
            data => {},
            templates => {
                group => "text",
                detail => "DDH.color_picker.content",
                wrap_detail => "base_detail"
            }
        };
};

1;
