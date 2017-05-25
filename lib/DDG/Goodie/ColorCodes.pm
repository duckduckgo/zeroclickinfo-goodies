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
        (.*?)\s*(.+?)\brgb(?:\s+code)?|                            # handles "red rgb code", etc
        (.*?)\s*colou?r(?:\s+code)?(?:\s+for)?\s+(.+?)| # handles "rgb color code for red", "red color code for html", etc
        (.*?)(rgba)\s*:?\s*\(?\s*(.+?)\s*\)?|                      # handles "rgba( red )", "rgba:255,0,0", "rgba(255 0 0)", etc
        ([^\s]*?)\s*($typestr)\s*:?\s*\(?\s*(.+?)\s*\)?|           # handles "rgb( red )", "rgb:255,0,0", "rgb(255 0 0)", etc
        \#?([0-9a-f]{6})|\#([0-9a-f]{3})                           # handles #00f, #0000ff, etc
    )
    (?:(?:'?s)?\s+(inverse|negative|opposite))?
    (?:\sto\s(?:$typestr))?
    $/ix;

zci is_cached => 1;
zci answer_type => 'color_code';

my %trigger_invert = map { $_ => 1 } (qw( inverse negative opposite ));
my %trigger_filler = map { $_ => 1 } (qw( code ));

my $color_mix = Color::Mix->new;

sub percentify {
    my @out;
    push @out, ($_ <= 1 ? round(($_ * 100))."%" : round($_)) for @_;
    return @out;
}

handle matches => sub {

    my $color;
    my $filler_count;
    my $inverse;

    my $type    = 'rgb8';    # Default type, can be overridden below.
    my @matches = @_;

    s/\sto\s(?:$typestr)//;

    $filler_count = 0;
    foreach my $q (map { lc $_ } grep { defined $_ } @matches) {
        # $q now contains the defined normalized matches which can be:
        if (exists $types{$q}) {
            $type = $types{$q};    # - One of our types.
        } elsif ($trigger_invert{$q}) {
            $inverse = 1;          # - An inversion trigger
        } elsif (!$trigger_filler{$q}) {    # - A filler word for more natural querying
            if ($q =~ /(?:^[a-z]+\s)+/) {
                $filler_count = $filler_count + 1;
            } else {
                $color = $q;                    # - A presumed color
            }
        }
    }

    return unless $color;                   # Need a color to continue!
    $color =~ s/\sto\s//;

    return if $filler_count;

    my $alpha = "1";
    $color =~ s/(,\s*|\s+)/,/g;             # Spaces to commas for things like "hsl 194 0.53 0.79"
    if ($color =~ s/#?([0-9a-f]{3,6})$/$1/) {    # Color looks like a hex code, strip the leading #
        $color = join('', map { $_ . $_ } (split '', $color)) if (length($color) == 3); # Make three char hex into six chars by repeating each in turn
        $type = 'rgb8';
    } elsif ($color =~ s/([0-9]+,[0-9]+,[0-9]+),([0]?\.[0-9]+)/$alpha = $2; $1/e) { #hack rgba into rgb and extract alpha
        $type = 'rgb8';
    } else {
        try {
            # See if we can find the color in one of our dictionaries.
            $color = join(',', Convert::Color::Library->new($color_dictionaries . '/' . $color)->as_rgb8->hex);
            $type = 'rgb8';    # We asked for rgb8 from our dictionary, so make sure our type matches.
        };
    }
    
    my $col = try  { Convert::Color->new("$type:$color") };    # Everything should be ready for conversion now.
    return unless $col;                                       # Guess not.

    if ($inverse) {                                           # We triggered on the inverse, so do the flip.
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
    my $show_column_2 = !($hsl[0] eq 0 && $hsl[1] eq '0%');
    
    my $column_2 = '';
    
    if ($show_column_2) {
        $column_2 = "\n" . "Complementary: #$complementary" . "\n" . "Analogous: #$analogous[0], #$analogous[1]";
    }
    
    return "$hexc ~ $rgb ~ $rgb_pct ~ $hslc ~ $cmyb$column_2",
    structured_answer => {
        data => {
            hex_code => $hex_code,
            hexc => $hexc,
            rgb => $rgb,
            hslc => $hslc,
            cmyb => $cmyb,
            show_column_2 => $show_column_2,
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
