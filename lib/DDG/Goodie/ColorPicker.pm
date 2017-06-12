package DDG::Goodie::ColorPicker;
# ABSTRACT: Presents a color picker that allows the user to select a color or build a color palette.

use DDG::Goodie;
use Color::Library;
use Text::Trim;
use strict;
use warnings;

zci answer_type => 'color_picker';

zci is_cached => 1;

triggers start => share("triggers.txt")->slurp;

my $goodie_version = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;

handle remainder_lc => sub {
    s/converter|conversion|colou?r//g;

    my $remainder = $_;
    trim($remainder);
    my $color = undef;
    my $path = "/share/goodie/color_picker/$goodie_version/";
    if ($remainder =~ /rgb\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/) {
        $color = join(',', 'rgb', $1, $2, $3);
    } elsif ($remainder =~ /hsv\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/) {
        $color = join(',', 'hsv', $1, $2, $3);
    } elsif ($remainder =~ /cmyk\(\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*,\s*(\d{1,3})\s*\)$/) {
        $color = join(',', 'cmyk', $1, $2, $3, $4);
    } elsif ($remainder =~ /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/) {
        $color = $remainder;
    } elsif ($remainder =~ /[a-zA-Z ]+/) {
        $remainder =~ s/[ \t]+//g;
        $remainder = lc $remainder;
        return unless defined Color::Library->SVG->color($remainder);
        $color = Color::Library->SVG->color($remainder)->html;
    }
    return 'Color Picker',
        structured_answer => {
            data => {
                color => $color,
                saturation_value_path => "${path}saturation_value_gradient.png",
                hue_path => "${path}hue_gradient.png"
            },
            templates => {
                group => 'text',
                options => {
                    content => "DDH.color_picker.content"
                }
            }
        };
};

1;
