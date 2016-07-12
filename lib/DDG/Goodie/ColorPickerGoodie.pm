package DDG::Goodie::ColorPickerGoodie;
# ABSTRACT: Presents a color picker that allows the user to select a color or build a color palette.

use DDG::Goodie;
use YAML::XS 'LoadFile';
use Color::Library;
use Data::Dumper;
use strict;
use warnings;

zci answer_type => 'color_picker_goodie';

zci is_cached => 1;

triggers start => ['color picker', 'colour picker', 'colorpicker', 'colourpicker'];

my $goodie_version = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;
# my $colors = LoadFile(share('colors.yml'));

handle remainder => sub {
    my $remainder = $_;
    my $color = undef;
    my $path = "/share/goodie/color_picker_goodie/$goodie_version/";
    if($remainder =~ /rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/) {
        $color = join(',', 'rgb', $1, $2, $3);
    }
    elsif($remainder =~ /hsv\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/) {
        $color = join(',', 'hsv', $1, $2, $3);
    }
    elsif($remainder =~ /cmyk\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/) {
        $color = join(',', 'cmyk', $1, $2, $3, $4);
    }
    elsif($remainder =~ /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/) {
        $color = $remainder;
    }
    elsif($remainder =~ /[a-zA-Z ]+/){
        $remainder =~ s/[ \t]+//g;
        $remainder = lc $remainder;
        if(defined Color::Library->SVG->color($remainder)) {
            $color = Color::Library->SVG->color($remainder)->html;
        }
        #$color = Color::Library->SVG->color($remainder);
        #if(exists Color::Library->SVG->color($remainder)){
        #}
    }
    return 'Color Picker',
        structured_answer => {
            id => 'color_picker_goodie',
            name => 'Color Picker Goodie',
            data => {
                color => $color,
                saturation_value_path => "${path}saturation_value_gradient.png",
                hue_path => "${path}hue_gradient.png"
            },
            templates => {
                group => 'text'
            }
        };
};

1;
