package DDG::Goodie::ColorCodes;
# ABSTRACT: Copious information about various ways ofencoding colors.

use DDG::Goodie;

use Color::Library;
use Convert::Color;
use Convert::Color::Library;
use Convert::Color::RGB8;
use Math::Round;
use Try::Tiny;

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
attribution cpan    => 'CRZEDPSYC' ;

sub percentify {
    my @out;
    push @out, ($_ <= 1 ? round(($_ * 100))."%" : round($_)) for @_;
    return @out;
}

my %trigger_invert = map { $_ => 1 } (qw( inverse negative opposite ));
my %trigger_filler = map { $_ => 1 } (qw( code ));

handle matches => sub {

    my $color;
    my $inverse;

    my $type    = 'rgb8';    # Default type, can be overridden below.
    my @matches = @_;

    foreach my $q (map { lc $_ } grep { defined $_ } @matches) {
        # $q now contains the defined normalized matches which can be:
        if (exists $types{$q}) {
            $type = $types{$q};    # - One of our types.
        } elsif ($trigger_invert{$q}) {
            $inverse = 1;          # - An inversion trigger
        } elsif (!$trigger_filler{$q}) {    # - A filler word for more natural querying
            $color = $q;                    # - A presumed color
        }
    }

    return unless $color;                   # Need a color to continue!

    $color =~ s/(,\s*|\s+)/,/g;             # Spaces to commas for things like "hsl 194 0.53 0.79"

    if ($color =~ s/#?([0-9a-f]{3,6})$/$1/) {    # Color looks like a hex code, strip the leading #
        $color = join('', map { $_ . $_ } (split '', $color)) if (length($color) == 3); # Make three char hex into six chars by repeating each in turn
        $type = 'rgb8';
    } else {
        try {
            # See if we can find the color in one of our dictionaries.
            $color = join(',', Convert::Color::Library->new($color_dictionaries . '/' . $color)->as_rgb8->hex);
            $type = 'rgb8';    # We asked for rgb8 from our dictionary, so make sure our type matches.
        };
    }

    my $col = try { Convert::Color->new("$type:$color") };    # Everything should be ready for conversion now.
    return unless $col;                                       # Guess not.

    if ($inverse) {                                           # We triggered on the inverse, so do the flip.
        my $orig_rgb = $col->as_rgb8;
        $col = Convert::Color::RGB8->new(255 - $orig_rgb->red, 255 - $orig_rgb->green, 255 - $orig_rgb->blue);
    }

    my $rgb = $col->as_rgb8;
    my $hsl = $col->as_hsl;

    my @color_template_data = (
        '#' . $rgb->hex,
        $col->as_rgb8->rgb8, percentify($col->as_rgb->rgb),
        round($hsl->hue), percentify($hsl->saturation, $hsl->lightness, $col->as_cmyk->cmyk));

    # Create the output!
    my $text = sprintf("Hex: %s ~ rgb(%d, %d, %d) ~ rgb(%s, %s, %s) ~ hsl(%d, %s, %s) ~ cmyb(%s, %s, %s, %s)", @color_template_data);
    my $html_text = sprintf("Hex: %s &middot; rgb(%d, %d, %d) &middot; rgb(%s, %s, %s) <br> hsl(%d, %s, %s) &middot; cmyb(%s, %s, %s, %s) &middot;",
        @color_template_data);
    return $text,
        html => '<div class="zci--color-codes"><div class="colorcodesbox" style="background:#'
      . $rgb->hex
      . '"></div>'
      . $html_text
      . " [<a href='http://labs.tineye.com/multicolr#colors="
      . $rgb->hex
      . ";weights=100;'>Images</a>] [<a href='http://www.color-hex.com/color/"
      . $rgb->hex
      . "' title='Tints, information and similar colors on color-hex.com'>Info</a>]</div>";
};

1;
