package DDG::Goodie::ColorCodes;

use DDG::Goodie;
use Convert::Color;
use Convert::Color::Library;

my %types = ( # hash of keyword => Convert::Color prefix
        vga     => 'vga',
        rgb     => 'rgb8',
        hsv     => 'hsv',
        hex     => 'rgb8',
        html    => 'rgb8',
        css     => 'rgb8',
        hsl     => 'hsl',
        hsv     => 'hsv',
        cmy     => 'cmy',
        cmyk    => 'cmyk',
        cmyb    => 'cmyb',
        );

my $typestr = join '|', keys %types;

triggers query_raw => qr/^
    (?:(.+)\s+(.+)\s+colou?r(?:\s+code)|           # handles "rgb red color code", "red rgb color code", etc
    (.+)\s+colou?r(?:\s+code)?(?:\s+for)?\s+(.+)|  # handles "rgb color code for red", "red color code for html", etc
    ($typestr)\s*:?\s*\(?\s*(.+?)\s*\)?)           # handles "rgb( red )", "rgb:255,0,0", "rgb(255 0 0)", etc
    $/ix;

zci is_cached => 1;
zci answer_type => 'color_code';

attribution 
    twitter => 'crazedpsyc',
    cpan    => 'CRZEDPSYC'
;

handle matches => sub {
    my $type;
    my $color;
    for (@_) {
        next unless defined $_;
        my $q = lc($_);
        $type = $types{$q} if exists $types{$q};
        $color = $q unless defined $type && exists $types{$q};
    }
    return unless $type && $color;

    $color =~ s/,?\s+/,/g;

    eval { $color = join(',',Convert::Color::Library->new($color)->as_rgb8->hex); $type = 'rgb8'; };

    my $col;
    eval { $col = Convert::Color->new("$type:$color"); };
    return if $@;

    my $rgb = $col->as_rgb8;
    my $hsl = $col->as_hsl;
    my $text = sprintf("Hex: %s, Red: %d, Green: %d, Blue: %d ~ Hue: %d, Saturation: %.2f, Value: %.2f ~ Cyan: %.2f, Magenta: %.2f, Yellow: %.2f, Black: %.2f", '#'.$rgb->hex, $col->as_rgb8->rgb8, $hsl->hue, $hsl->saturation, $hsl->lightness, $col->as_cmyk->cmyk);
    return $text, html => '<div style="background:#'.$rgb->hex.';border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>'.$text;
};

1;
