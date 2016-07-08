package DDG::Goodie::ColorPicker;
# ABSTRACT: Presents a color picker that allows the user to select a color or build a color palette.

use DDG::Goodie;
use YAML::XS 'LoadFile';
use strict;
use warnings;

zci answer_type => 'color_picker';

zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers start => ['color picker', 'colour picker', 'colorpicker', 'colourpicker', 'manrajtest'];

my $goodie_version = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;
my $colors = LoadFile(share('colors.yml'));

# Handle statement
handle remainder => sub {
    my $remainder = $_;
    my $color = undef;
    my $path = "/share/goodie/color_picker/$goodie_version/";
    if($remainder =~ /rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/) {
        $color = 'rgb,'.$1.','.$2.','.$3;
    }
    elsif($remainder =~ /hsv\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/) {
        $color = 'hsv,'.$1.','.$2.','.$3;
    }
    elsif($remainder =~ /cmyk\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/) {
        $color = 'cmyk,'.$1.','.$2.','.$3.','.$4;
    }
    elsif($remainder =~ /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/) {
        $color = $remainder;
    }
    print $colors;
    return "",
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
