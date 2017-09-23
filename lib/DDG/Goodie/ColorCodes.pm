package DDG::Goodie::ColorCodes;
# ABSTRACT: Copious information about various ways of encoding colors.

use strict;
use DDG::Goodie;

use Color::Library;
use Color::Mix;
use Convert::Color;
use Convert::Color::Library;
use Convert::Color::RGB8;
use Math::Round;
use Try::Tiny;

my %types = ( # hash of keyword => Convert::Color prefix
        rgba    => 'rgb8',
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

my $inverse_words = qr/inverse|negative|opposite/;

my $trigger_and_guard = qr/^
    (?:what(?:\si|'?)s \s* (?:the)? \s+)? # what's the, whats the, what is the, what's, what is, whats
    (?<inv>$inverse_words\s+(?:of)?(?:\s?the\s?)?)?
    (?:
        red:\s*(?<r>[0-9]{1,3})\s*green:\s*(?<g>[0-9]{1,3})\s*blue:\s*(?<b>[0-9]{1,3})| # handles red: x green: y blue: z
        (?<type>$typestr)\s*colou?r(?:\s+code)?(?:\s+for)?\s+(?<color>.+?)|             # handles "rgb color code for red", "red color code for html", etc
        (?<type>$typestr)\s*:?\s*\(?\s*(?<color>.+?)\s*\)?|                             # handles "rgb( red )", "rgb:255,0,0", "rgb(255 0 0)", etc
        (?<color>.+?)\b(rgb|css|html)(?:\s+code)?|                                      # handles "red rgb code", etc
        \#?(?<color>[0-9a-f]{6})|\#(?<color>[0-9a-f]{3})                                # handles #00f, #0000ff, etc
    )
    (?<inv>(?:'?s)?\s+$inverse_words)?
    (?:\sto\s(?:$typestr))?
$/ix;

triggers query_raw => $trigger_and_guard;

zci is_cached => 1;
zci answer_type => 'color_code';

my $color_mix = Color::Mix->new;

sub percentify {
    return map { ($_ <= 1 ? round(($_ * 100))."%" : round($_)) } @_;
}

handle query_lc => sub {

    my $color;
    my $alpha = "1";
    my $inverse = 0;
    my $type = 'rgb8';

    s/\sto\s(?:$typestr)?//g;

    $_ =~ $trigger_and_guard;
    $type = $types{lc $+{'type'}} if defined $+{'type'} and exists $types{lc $+{'type'}};

    $color = "$+{'r'} $+{'g'} $+{'b'}" if defined $+{'r'} and defined $+{'g'} and defined $+{'b'};
    $color = lc $+{'color'} if defined $+{'color'};

    $inverse = 1 if defined $+{'inv'};
    $color =~ s/,?\s+/,/g;
    $color =~ s/([0-9]+,[0-9]+,[0-9]+),([0]?\.[0-9]+)/$alpha = $2; $1/e;

    if ($color =~ s/#?([0-9a-f]{3,6})$/$1/) {
        $color = join('', map { $_ . $_ } (split '', $color)) if (length($color) == 3);
        $type = 'rgb8';
    } else {
        try {
            $color = join(',', Convert::Color::Library->new($color_dictionaries . '/' . $color)->as_rgb8->hex);
            $type = 'rgb8';
        };
    }
    
    my $col = try { Convert::Color->new("$type:$color") };
    return unless $col;

    if ($inverse) {
        my $orig_rgb = $col->as_rgb8;
        $col = Convert::Color::RGB8->new(255 - $orig_rgb->red, 255 - $orig_rgb->green, 255 - $orig_rgb->blue);
    }

    my $hex_code = $col->as_rgb8->hex;

    my $complementary = $color_mix->complementary($hex_code);
    my @analogous = $color_mix->analogous($hex_code,12,12);
    @analogous = (uc($analogous[1]), uc($analogous[11]));
    my @rgb = $col->as_rgb8->rgb8;
    my $hsl = $col->as_hsl;
    my @rgb_pct = percentify($col->as_rgb->rgb);
    my @cmyk = percentify($col->as_cmyk->cmyk);

    my @hsl = (round($hsl->hue), percentify($hsl->saturation), percentify($hsl->lightness));

    my $hexc = 'Hex: #' . uc($hex_code);
    my $rgb = 'RGBA(' . join(', ', @rgb) . ', ' . $alpha . ')';
    my $hslc = 'HSL(' . join(', ', @hsl) . ')';
    my $cmyb = 'CMYB(' . join(', ', @cmyk) . ')';
    my $rgb_pct = 'RGB(' . join(', ', @rgb_pct) . ')';
    
    $complementary = uc($complementary);
    
    #greyscale colours have no hue and saturation
    my $hide_column_2 = ($hsl[0] eq 0 && $hsl[1] eq '0%');
    
    my $column_2 = $hide_column_2 ? "" : "\nComplementary: #$complementary\nAnalogous: #$analogous[0], #$analogous[1]";
    
    return "$hexc ~ $rgb ~ $rgb_pct ~ $hslc ~ $cmyb$column_2",
    structured_answer => {
        data => {
            hex_code => $hex_code,
            hexc => $hexc,
            rgb => $rgb,
            hslc => $hslc,
            cmyb => $cmyb,
            show_column_2 => !$hide_column_2,
            analogous => \@analogous,
            complementary => $complementary,
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.color_codes.content'
            }
        }
    };      
};

1;
