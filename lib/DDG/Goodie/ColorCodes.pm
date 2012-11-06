package DDG::Goodie::ColorCodes;

use DDG::Goodie;
use Convert::Color;
use Convert::Color::Library;
use Math::Round;

my %types = ( # hash of keyword => Convert::Color prefix
        rgb     => 'rgb8',
        hex     => 'rgb8',
        html    => 'rgb8',
        css     => 'rgb8',
        color   => 'rgb8',
        hsl     => 'hsl',
        hsv     => 'hsv',
        cmy     => 'cmy',
        cmyk    => 'cmyk',
        cmyb    => 'cmyk',
        );

my $typestr = join '|', keys %types;
$typestr =~ s/([#\^\$\*\+\?])/\\$1/g;

triggers query_raw => qr/^
    (?:(.+)\s+(.+)\s+colou?r(?:\s+code)?|          # handles "rgb red color code", "red rgb color code", etc
    (.+)\s+colou?r(?:\s+code)?(?:\s+for)?\s+(.+)|  # handles "rgb color code for red", "red color code for html", etc
    ($typestr)\s*:?\s*\(?\s*(.+?)\s*\)?|           # handles "rgb( red )", "rgb:255,0,0", "rgb(255 0 0)", etc
    \#?([0-9a-f]{6})|\#([0-9a-f]{3}))              # handles #00f, #0000ff, etc
    $/ix;

zci is_cached => 1;
zci answer_type => 'color_code';

primary_example_queries 'hex color code for cyan';
secondary_example_queries 'rgb(173,216,230)', 'hsl 194 0.53 0.79', 'cmyk(0.12, 0, 0, 0)', '#00ff00';
description 'get hex, RGB, HSL and CMYB values for a color';
name 'ColorCodes';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ColorCodes.pm';
category 'conversions';
topics 'programming';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

sub percentify {
    my @out;
    push @out, ($_ <= 1 ? round(($_ * 100))."%" : round($_)) for @_;
    return @out;
}

handle matches => sub {
    my $type;
    my $color;
    for (@_) {
        next unless defined $_;
        my $q = lc($_);
        $type = $types{$q} if exists $types{$q};
        $color = $q unless defined $type && exists $types{$q};
    }

    my @colorin = split /(?:,\s*|\s+)/, $color;
    my @colorout;

    for (@colorin) {
        # handle percents
        if (/(\d+(?:\.\d+)?)%$/) {
            my $num = $1;
            $num =~ s/\.//;
            my $len = length($num);
            return unless $len > 0 && $len <= 3;
            push @colorout, "0.0$num" if $len == 1;
            push @colorout, "0.$num" if $len == 2;
            push @colorout, "$num" if $len == 3;
            $type = 'rgb' if $type eq 'rgb8';
        }
        else { push @colorout, $_; }
    }
    $color = join ',', @colorout;

    if ($color =~ /^([0-9a-f]{3,6})$/) {
        if(length($color) == 3) { 
            $color = '';
            $color .= $_.$_ for split '', $1;
        }
        $type = 'rgb8';
    }

    return unless $type && $color;

    eval { $color = join(',',Convert::Color::Library->new($color)->as_rgb8->hex); $type = 'rgb8'; };

    my $col;
    eval { $col = Convert::Color->new("$type:$color"); };
    return if $@;

    my $rgb = $col->as_rgb8;
    my $hsl = $col->as_hsl;
    my $text = sprintf("Hex: %s ~ rgb(%d, %d, %d) ~ rgb(%s, %s, %s) ~ hsl(%d, %s, %s) ~ cmyb(%s, %s, %s, %s)", '#'.$rgb->hex, $col->as_rgb8->rgb8, percentify($col->as_rgb->rgb), round($hsl->hue), percentify($hsl->saturation, $hsl->lightness, $col->as_cmyk->cmyk));
    return $text, html => '<div style="background:#'.$rgb->hex.';border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>'.$text." [<a href='http://labs.tineye.com/multicolr#colors=".$rgb->hex.";weights=100;'>Images</a>]";
};

1;
