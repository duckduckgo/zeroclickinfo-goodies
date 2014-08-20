package DDG::Goodie::ColorCodes;
# ABSTRACT: Copious information about various ways ofencoding colors.

use DDG::Goodie;

use Color::Library;
use Convert::Color;
use Convert::Color::Library;
use Convert::Color::RGB8;
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

# Eliminate NBS_ISCC sub-dictionaries from our lookups.
# They contain "idiosyncratic" color names (including 'email' in NBS_ISCC::M) which will
# otherwise cause this to return answers for which no one was looking.
my $color_dictionaries = join(',', grep { $_ !~ /^nbs-iscc-/ } map { $_->id } Color::Library->dictionaries);

my $typestr = join '|', sort { length $b <=> length $a } keys %types;
$typestr =~ s/([#\^\$\*\+\?])/\\$1/g;

triggers query_raw => qr/^
    (?:what(?:\si|'?)s \s* (?:the)? \s+)? # what's the, whats the, what is the, what's, what is, whats
    (?:(inverse|negative|opposite)\s+(?:of)?)?
    (?:
        (.*?)\s*(.+?)\bcolou?r(?:\s+code)?|             # handles "rgb red color code", "red rgb color code", etc
        (.*?)\s*(.+?)\brgb(?:\s+code)?|             # handles "red rgb code", etc
        (.*?)\s*colou?r(?:\s+code)?(?:\s+for)?\s+(.+?)|  # handles "rgb color code for red", "red color code for html", etc
        (.*?)($typestr)\s*:?\s*\(?\s*(.+?)\s*\)?|           # handles "rgb( red )", "rgb:255,0,0", "rgb(255 0 0)", etc
        \#?([0-9a-f]{6})|\#([0-9a-f]{3})               # handles #00f, #0000ff, etc
    )
    (?:(?:'?s)?\s+(inverse|negative|opposite))?
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
    my $inverse;

    for (@_) {
        next unless defined $_;
        my $q = lc;
        $type = $types{$q} if exists $types{$q};
       
        if ($q =~ /\b(?:inverse|negative|opposite|code)\b/) {
            $inverse = 1;
        } 
        
        else {
            $color = $q unless defined $type && exists $types{$q};
        }
    }
    $type //= 'rgb8';

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

    eval { $color = join(',',Convert::Color::Library->new($color_dictionaries.'/'.$color)->as_rgb8->hex); $type = 'rgb8'; };

    my $col;
    eval { $col = Convert::Color->new("$type:$color"); };
    return if $@;

    if ($inverse) {
        my $rgb = $col->as_rgb8;
        $col = Convert::Color::RGB8->new(255 - $rgb->red, 255 - $rgb->green, 255 - $rgb->blue);
    }

    my $rgb = $col->as_rgb8;
    my $hsl = $col->as_hsl;
    my $text = sprintf("Hex: %s ~ rgb(%d, %d, %d) ~ rgb(%s, %s, %s) ~ hsl(%d, %s, %s) ~ cmyb(%s, %s, %s, %s)", '#'.$rgb->hex, $col->as_rgb8->rgb8, percentify($col->as_rgb->rgb), round($hsl->hue), percentify($hsl->saturation, $hsl->lightness, $col->as_cmyk->cmyk));
    return $text, html => '<div style="background:#'.$rgb->hex.';border:2px solid #999;height:30px;width:30px;margin:5px;margin-right:10px;margin-top:3px;float:left;"></div>'.$text." [<a href='http://labs.tineye.com/multicolr#colors=".$rgb->hex.";weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/".$rgb->hex."' title='Tints, information and similar colors on color-hex.com'>Info</a>]";
};

1;
