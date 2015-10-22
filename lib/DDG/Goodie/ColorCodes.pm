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
        (.*?)\s*(.+?)\brgb(?:\s+code)?|                 # handles "red rgb code", etc
        (.*?)\s*colou?r(?:\s+code)?(?:\s+for)?\s+(.+?)| # handles "rgb color code for red", "red color code for html", etc
        (.*?)(rgba)\s*:?\s*\(?\s*(.+?)\s*\)?|           # handles "rgba( red )", "rgba:255,0,0", "rgba(255 0 0)", etc
        ([^\s]*?)\s*($typestr)\s*:?\s*\(?\s*(.+?)\s*\)?|       # handles "rgb( red )", "rgb:255,0,0", "rgb(255 0 0)", etc
        \#?([0-9a-f]{6})|\#([0-9a-f]{3})                # handles #00f, #0000ff, etc
    )
    (?:(?:'?s)?\s+(inverse|negative|opposite))?
    (?:\sto\s(?:$typestr))?
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
attribution  cpan   => 'CRZEDPSYC',
             github => ['http://github.com/mintsoft', 'Rob Emery'];

my %trigger_invert = map { $_ => 1 } (qw( inverse negative opposite ));
my %trigger_filler = map { $_ => 1 } (qw( code ));

my $color_mix = Color::Mix->new;

sub percentify {
    my @out;
    push @out, ($_ <= 1 ? round(($_ * 100))."%" : round($_)) for @_;
    return @out;
}

sub create_output {
    my (%input) = @_;
    my ($text, $html) = ("","");

    (my $hex_for_links = $input{'hex'}) =~ s/^#//;
    my $hex = "Hex: ".uc($input{'hex'});
    my $rgb = "RGBA(" . join(", ", @{$input{'rgb'}}) . ", ".$input{'alpha'}.")";
    my $rgb_pct = "RGB(" . join(", ", @{$input{'rgb_percentage'}}) . ")";
    my $hsl = "HSL(" . join(", ", @{$input{'hsl'}}) . ")";
    my $cmyb = "CMYB(" . join(", ", @{$input{'cmyb'}}) . ")";
    my @analogous_colors = @{$input{'analogous'}};
    my $complementary = uc $input{'complementary'};

    #greyscale colours have no hue and saturation
    my $show_column_2 = !($input{'hsl'}->[0] eq 0 && $input{'hsl'}->[1] eq '0%');
    
    $text = "$hex ~ $rgb ~ $rgb_pct ~ $hsl ~ $cmyb";
    my $column_2_text = "\n" .
            "Complementary: #$complementary\n" .
            "Analogous: ".(join ", ", map { "#".uc $_ } @analogous_colors);

    my $comps = "<div class='cols_column'>"
              . "<a href='/?q=color%20picker%20%23$complementary' class='mini-color circle' style='background: #$complementary'>"
              . "</a></div>"
              . "<div class='desc_column'><p class='no_vspace'>Complementary #:</p><p class='no_vspace'>"
              . qq[<a onclick='document.x.q.value="#$complementary";document.x.q.focus();' href='javascript:' class='tx-clr--lt'>$complementary</a>]
              . "</p></div>";

    my $analogs = "<div class='cols_column'>"
                . (join "", map { "<a href='/?q=color%20picker%20%23".$_."' class='mini-color circle' style='background: #" . $_ . "'> </a>"; } @analogous_colors)
                . "</div>"
                . "<div class='desc_column'><p class='no_vspace'>Analogous #:</p><p class='no_vspace'>" . (join ", ", map { qq[<a onclick='document.x.q.value="#] .(uc $_). qq[";document.x.q.focus();' href='javascript:' class='tx-clr--lt'>].(uc $_).'</a>' } @analogous_colors) . "</p></div>";

    $html = "<div class='column1 tx-clr--dk2'>"
          . "<p class='hex tx-clr--dk zci__caption'>$hex</p><p class='no_vspace'>$rgb</p><p class='no_vspace'>$hsl</p><p class='no_vspace'>$cmyb</p>"
          . "<p><a href='http://labs.tineye.com/multicolr/#colors=" . $hex_for_links . ";weights=100;' class='tx-clr--dk2'>Images</a>"
          . "<span class='separator'> | </span>"
          . "<a href='http://www.color-hex.com/color/" . $hex_for_links . "' title='Tints, information and similar colors on color-hex.com' class='tx-clr--dk2'>Info</a>"
          . "<span class='separator'> | </span>"
          . "<a href='/?q=color%20picker%20%23" . $hex_for_links . "' class='tx-clr--dk2'>Picker</a></p>"
          . "</div>";
          
    my $column_2_html = "<div class='column2 tx-clr--dk2'>"
          . "<div class='complementary'>$comps</div>"
          . "<div>$analogs</div>"
          . "</div>";
    
    if ($show_column_2) {
        $html.= $column_2_html;
        $text.= $column_2_text;
    }
    
    return ($text, $html);
}

handle matches => sub {

    my $color;
    my $inverse;

    my $type    = 'rgb8';    # Default type, can be overridden below.
    my @matches = @_;

    s/\sto\s(?:$typestr)//;

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
    $color =~ s/\sto\s//;

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

    my $col = try { Convert::Color->new("$type:$color") };    # Everything should be ready for conversion now.
    return unless $col;                                       # Guess not.

    if ($inverse) {                                           # We triggered on the inverse, so do the flip.
        my $orig_rgb = $col->as_rgb8;
        $col = Convert::Color::RGB8->new(255 - $orig_rgb->red, 255 - $orig_rgb->green, 255 - $orig_rgb->blue);
    }

    my $hex_code = $col->as_rgb8->hex;

    my $complementary = $color_mix->complementary($hex_code);
    my @analogous = $color_mix->analogous($hex_code,12,12);
    @analogous = ($analogous[1], $analogous[11]);
    my @rgb = $col->as_rgb8->rgb8;
    my $hsl = $col->as_hsl;
    my @rgb_pct = percentify($col->as_rgb->rgb);
    my @cmyk = percentify($col->as_cmyk->cmyk);
    my %outdata = (
        hex => '#' . $hex_code,
        rgb => \@rgb,
        rgb_percentage => \@rgb_pct,
        hsl => [round($hsl->hue), percentify($hsl->saturation), percentify($hsl->lightness)],
        cmyb => \@cmyk,
        alpha => $alpha,
        complementary => $complementary,
        analogous => \@analogous
    );

    my ($text, $html_text) = create_output(%outdata);

    return $text,
        html => '<div class="zci--color-codes"><a href="/?q=color%20picker%20%23' . $hex_code . '" '
          . 'class="colorcodesbox circle" style="background:#' . $hex_code . '">'
          . '</a>'
          . $html_text
          . "</div>";
};

1;
