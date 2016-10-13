package DDG::Goodie::RgbColor;

use DDG::Goodie;
use strict;
use warnings;

use List::Util qw(first sum);
use Color::Library;
use Color::RGB::Util qw(
    mix_2_rgb_colors
    rand_rgb_color
    reverse_rgb_color
    tint_rgb_color
);
use Lingua::StopWords qw(getStopWords);
use Lingua::EN::StopWords qw(%StopWords);
use Convert::Color::RGB8;
use Math::Round;

with 'DDG::GoodieRole::NumberStyler';

zci answer_type => 'rgb_color';

zci is_cached => 0;

my @opposite_words = ('opposite', 'complement', 'complementary');
my @color_words = map { $_, "${_}s" } ('color', 'colour');
my @mix_words = ('mix', 'mixed', 'mixing');
my @tint_words = ('tint', 'tinted', 'tinting');
my @add_words = ('+', 'plus', 'add');
triggers any =>
    @color_words, @mix_words,
    @opposite_words, @tint_words,
    @add_words;

#####################
#  Color Constants  #
#####################

# Favored dictionaries should be closer to the end (those with preferable
# names).
my @dicts = Color::Library->dictionaries(qw(
    x11 nbs_iscc nbs_iscc::a nbs_iscc::b nbs_iscc::f nbs_iscc::h
    nbs_iscc::m nbs_iscc::p nbs_iscc::r nbs_iscc::rc nbs_iscc::s
    nbs_iscc::sc nbs_iscc::tc netscape windows ie vaccc html mozilla svg
    www
));
my @dict_colors = map { $_->colors } @dicts;
my %colors = map { (lc $_->title =~ s/-/ /gr) => $_, lc $_->name => $_ } @dict_colors;
my @color_descs = sort { length $b <=> length $a } keys %colors;

my %hex_to_color = map { $_->hex => $_ } @dict_colors;
my $color_name_re = '(?:' .
    (join '|', map { quotemeta $_ } @color_descs) . ')';
$color_name_re =~ s/\\ /[ -]?/g;

my $scolor = 'colou?rs?';
my $color_re = qr/(?:$color_name_re|#?(\p{XDigit}{6}|\p{XDigit}{3}))/;

# Some stop words relevant to color queries.
my @custom_stops = (
    'make', 'makes',
    'paint', 'paints',
);
my %stops = (%StopWords, %{getStopWords('en')});
my @stopwords = (keys %stops, @custom_stops);
my $stop_re = '(?:' . (join '|', map { quotemeta $_ } @stopwords) . ')';

my $black = Color::Library->color('black');
my $white = Color::Library->color('white');

#############
#  Helpers  #
#############

sub normalize_color {
    my $color = shift;
    return $color if ref $color eq 'Color::Library::Color';
    $color =~ s/-/ /g;
    return $colors{$color} if exists $colors{$color};
    $color =~ s/ //g;
    return $colors{$color} if exists $colors{$color};
    my $hex = $color =~ s/^#//gr;
    $hex =~ /^.{3}$/
        ? join '', map { "$_$_" } split '', $hex
        : $hex;
}

sub common_name {
    my $color = $hex_to_color{$_[0]} or return '';
    return $color->name;
}

sub common_title {
    my $color = $hex_to_color{$_[0]} or return '';
    return $color->title;
}

sub normalize_colors_for_template {
    map { normalize_color_for_template($_) } @_;
}

sub percentify {
    my @out;
    push @out, ($_ <= 1 ? round(($_ * 100))."%" : round($_)) for @_;
    return @out;
}

sub normalize_color_for_template {
    my $color_s = shift;
    my $color = $color_s;
    my %additional;
    if (ref $color_s eq 'HASH') {
        $color = delete $color_s->{color};
        %additional = %$color_s;
    }
    my $name = '';
    my $title = '';
    my $hex;
    if (ref $color eq 'Color::Library::Color') {
        $name = $color->name;
        $title = $color->title;
        $hex  = $color->hex;
    } else {
        $color = normalize_color($color);
        $name = common_name($color);
        $title = common_title($color);
        $hex  = $color =~ s/^#//r;
    }
    $title = ucfirst $title;
    $color = Convert::Color->new("rgb8:$hex");
    my @rgb = $color->as_rgb8->rgb8;
    my $hex_disp = 'Hex: #' . uc $hex;
    my $rgb_disp = 'RGB(' . join(', ', @rgb) . ')';
    my $hsl = $color->as_hsl;
    my @hsl = (
        round($hsl->hue),
        percentify($hsl->saturation),
        percentify($hsl->lightness)
    );
    my $hsl_disp = 'HSL(' . join(', ', @hsl). ')';
    my @cmyb = percentify($color->as_cmyk->cmyk);
    my $cmyb_disp = 'CMYB(' . join(', ', @cmyb) . ')';
    return {
        %additional,
        hex       => $hex,
        name      => $name,
        title     => $title,
        hex_disp  => $hex_disp,
        hslc_disp => $hsl_disp,
        rgb_disp  => $rgb_disp,
        cmyb_disp => $cmyb_disp,
    };
}

sub right_decimal_from_amount {
    my ($amt_l, $amt_r, $type) = @_;
    return if $amt_l < 0 || $amt_r < 0 || $amt_l + $amt_r == 0;
    if ($type eq 'part') {
        my $total = $amt_l + $amt_r;
        my $significance = $amt_r / $total;
        return $significance;
    }
    if ($type eq 'percent') {
        return unless $amt_l + $amt_r == 100;
        return $amt_r / 100;
    }
}

sub normalize_amounts_for_template {
    my ($type, @amounts) = @_;
    if ($type eq 'part') {
        my $tot = sum @amounts;
        @amounts = map { ($_ / $tot) } @amounts;
    } elsif ($type eq 'percent') {
        @amounts = map { $_ / 100 } @amounts;
    }
    return @amounts;
}

###############
#  Relevancy  #
###############

sub probably_relevant {
    my $text = shift;
    return 1 if $text =~ /$scolor/;
    return 0;
}

sub remainder_probably_relevant {
    my ($remainder) = @_;
    $remainder =~ s/\b$stop_re\b//go;
    $remainder =~ s/^\s+//;
    $remainder =~ s/\s+$//;
    return 1 if $remainder eq '';
    return probably_relevant($remainder);
}

####################
#  Query Handlers  #
####################

my $mix_re     = qr/(?:mix(ed|ing)?|=)/;
my $tint_re    = qr/tint(ed|ing)?/;
my $reverse_re = qr/(opposite|complement(ary)?)( $scolor)?( (of|to|for))?/;
my $random_re  = qr/rand(om)? $scolor/;

my $add_re   = qr/(?: ?\+ ?| (add|plus) )/;
my $dual_con = qr/( (and|with))? /;
my $mix_con  = qr/($add_re|$dual_con)/;
my $tint_con = $dual_con;

my $number_re = number_style_regex();
my $amount_re = qr/(?:(?<n>$number_re)((?<t>%)|(?<t>part)s?))/;
my $color_amount = qr/((?<a>$amount_re) )?(?<c>$color_re)/;
my $pct_re = qr/(?<n>$number_re)(?<t>%)/;
my $color_amount_pct = qr/((?<a>$pct_re) )?(?<c>$color_re)/;
my $mix_l = qr/(?<m1>$color_amount)/;
my $mix_r = qr/(?<m2>$color_amount)/;
my $tint_l = qr/(?<c1>$color_re)/;
my $tint_r = qr/(?<m2>$color_amount_pct)/;
my $dual_colors_and = qr/(?<c1>$color_re)( and)? (?<c2>$color_re)/;

sub build_dual_colors {
    my ($phrase, $con, $l, $r) = @_;
    my $dual_start = qr/$phrase $l$con$r/;
    my $dual_middle_end = qr/$l( $phrase$con$r|$con$r $phrase)/;
    return qr/($dual_start|$dual_middle_end)/;
}

my %query_forms_full = (
    mix     => build_dual_colors($mix_re, $mix_con, $mix_l, $mix_r),
    random  => qr/$random_re( between $dual_colors_and)?$/,
    reverse => qr/$reverse_re (?<c>$color_re)/,
    tint    => build_dual_colors($tint_re, $tint_con, $tint_l, $tint_r),
);

# Quickly check the query before we use the full regex.
my %query_forms_qc = (
    mix     => $mix_re,
    random  => $random_re,
    reverse => $reverse_re,
    tint    => $tint_re,
);

my %query_forms_fns = (
    mix     => \&mix_colors,
    random  => \&random_color,
    reverse => \&reverse_color,
    tint    => \&tint_color,
);

my @query_types = sort keys %query_forms_fns;

sub amount_type_from_text {
    my $text = shift;
    $text =~ /^$amount_re$/;
    my $amt = $+{n};
    my $type = $+{t};
    $amt =~ s/\s+//g;
    $type = 'percent' if $type eq '%';
    return ($amt, $type);
}

sub random_color {
    my %cap = @_;
    srand;
    my $c1 = normalize_color($cap{c1} // $black);
    my $c2 = normalize_color($cap{c2} // $white);
    my %data = (
        subtitle_prefix => 'Random color between',
        input_colors => [normalize_colors_for_template($c1, $c2)],
    );
    my %result;
    my $color = normalize_color_for_template(rand_rgb_color($c1, $c2));
    $data{result_color} = $color;
    $result{data} = \%data;
    return %result;
}

sub mix_colors {
    my %caps = @_;
    $caps{m1} =~ /^$color_amount$/;
    my $c1 = normalize_color($+{c});
    my $a1 = $+{a};
    $caps{m2} =~ /^$color_amount$/;
    my $c2 = normalize_color($+{c});
    my $a2 = $+{a};
    my $pct = 0.5;
    my $amt1 = 0.5;
    my $amt2 = 0.5;
    if ($a1 // $a2) {
        ($amt1, my $t1) = amount_type_from_text($a1);
        ($amt2, my $t2) = amount_type_from_text($a2);
        return unless $t1 eq $t2;
        $pct = right_decimal_from_amount($amt1, $amt2, $t1) // return;
        ($amt1, $amt2) = normalize_amounts_for_template($t1, $amt1, $amt2);
    }
    my %data = (
        subtitle_prefix => 'Mix',
        input_colors => [normalize_colors_for_template(
            { color => $c1, amount => $amt1, },
            { color => $c2, amount => $amt2, },
        )],
    );
    my %result;
    my $color = normalize_color_for_template(mix_2_rgb_colors($c1, $c2, $pct));
    $data{result_color} = $color;
    $result{data} = \%data;
    return %result;
}

sub tint_color {
    my %caps = @_;
    my $c1 = normalize_color($caps{c1});
    $caps{m2} =~ /^$color_amount$/;
    my $c2 = normalize_color($+{c});
    my $a1 = $+{a};
    my $pct = 0.5;
    my $amt1 = 0.5;
    if ($a1) {
        ($amt1, my $t1) = amount_type_from_text($a1);
        return unless $t1 eq 'percent';
        my $amt2 = 100 - $amt1;
        $pct = right_decimal_from_amount($amt2, $amt1, $t1) // return;
        ($amt1, $amt2) = normalize_amounts_for_template($t1, $amt1, $amt2);
    }
    my %data = (
        subtitle_prefix => 'Tint',
        input_colors => [normalize_colors_for_template(
            { color => $c1, },
            { color => $c2, amount => $amt1, },
        )],
    );
    my %result;
    my $color = normalize_color_for_template(tint_rgb_color($c1, $c2, $pct));
    $data{result_color} = $color;
    $result{data} = \%data;
    return %result;
}

sub reverse_color {
    my %cap = @_;
    my $c = normalize_color($cap{c});
    my $color = normalize_color_for_template(reverse_rgb_color($c));
    return (
        data => {
            subtitle_prefix => '(RGB) Opposite color of',
            input_colors    => [normalize_color_for_template($c)],
            result_color    => $color,
        },
    );
}

sub normalize_result {
    my %result = @_ or return;
    $result{text_answer} = $result{data}->{result_color}{hex};
    return %result;
}

handle query_lc => sub {
    my $query = $_;
    $query =~ s/[.?!]$//;

    my %cap;
    my $rem;
    my $type = first {
        my $qc = $query_forms_qc{$_};
        if ($query =~ $qc) {
            $rem = $query =~ s/$query_forms_full{$_}//r;
            if ($rem ne $query) {
                %cap = %+;
                1;
            } else {
                0;
            }
        } else {
            0;
        }
    } @query_types or return;
    return unless remainder_probably_relevant($rem);
    my $action = $query_forms_fns{$type};
    my %result = normalize_result($action->(%cap)) or return;

    return $result{text_answer},
        structured_answer => {

            data => $result{data},

            templates => {
                group   => "text",
                options => {
                    content => 'DDH.rgb_color.content',
                },
            }
        };
};

1;
