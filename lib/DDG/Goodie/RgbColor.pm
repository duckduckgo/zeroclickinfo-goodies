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
);
use Lingua::StopWords qw(getStopWords);
use Lingua::EN::StopWords qw(%StopWords);

with 'DDG::GoodieRole::NumberStyler';

zci answer_type => 'rgb_color';

zci is_cached => 0;

my @opposite_words = ('opposite', 'complement', 'complementary');
my @color_words = map { $_, "${_}s" } ('color', 'colour');
my @mix_words = ('mix', 'mixed', 'mixing');
triggers any => @color_words, @mix_words, @opposite_words;

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
my %colors = map { lc $_->title => $_, lc $_->name => $_ } @dict_colors;
my @color_descs = sort { length $b <=> length $a } keys %colors;

my %hex_to_color = map { $_->html => $_ } @dict_colors;
my $color_name_re = '(?:' .
    (join '|', map { quotemeta $_ } @color_descs) . ')';

my $scolor = 'colou?rs?';
my $color_re = qr/(?:$color_name_re|#?\p{XDigit}{6})/;

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
    return $colors{$color} if exists $colors{$color};
    return $color if $color =~ /^#/;
    return "#$color";
}

sub common_name {
    my $color = $hex_to_color{$_[0]} or return '';
    return $color->name;
}

sub normalize_colors_for_template {
    map { normalize_color_for_template($_) } @_;
}

sub normalize_color_for_template {
    my $color_s = shift;
    my $color = $color_s;
    my %additional;
    if (ref $color_s eq 'HASH') {
        $color = delete $color_s->{color};
        %additional = %$color_s;
    }
    $color = normalize_color($color);
    my %res = ref $color eq 'Color::Library::Color' ? (
        hex  => $color->html,
        name => $color->name,
    ) : ( hex => $color, name => common_name($color) );
    return { %additional, %res };
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
    my ($form, $query) = @_;
    $query =~ s/$form//;
    $query =~ s/\b$stop_re\b//go;
    $query =~ s/^\s+//o;
    $query =~ s/\s+$//o;
    return 1 if $query eq '';
    return probably_relevant($query);
}

####################
#  Query Handlers  #
####################

my $mix_re = 'mix(ed|ing)?';
my $reverse_re = "(opposite|complement(ary)?)( $scolor)?( (of|to|for))?";

my $number_re = number_style_regex();
my $amount_re = qr/(?:(?<n>$number_re)((?<t>%)|(?<t>part)s?))/;
my $color_amount = qr/((?<a>$amount_re) )?(?<c>$color_re)/;
my $dual_colors_mix = qr/(?<m1>$color_amount)( (and|with))? (?<m2>$color_amount)/;
my $dual_colors_and = qr/(?<c1>$color_re)( and)? (?<c2>$color_re)/;

my %query_cat = (
    random => "rand(om)? $scolor( between $dual_colors_and)?\$",
    mix => "$mix_re $dual_colors_mix|$dual_colors_mix $mix_re",
    reverse => "$reverse_re (?<c>$color_re)",
);
my %query_forms = (
    $query_cat{mix}     => \&mix_colors,
    $query_cat{random}  => \&random_color,
    $query_cat{reverse} => \&reverse_color,
);

my @query_forms = keys %query_forms;

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
        subtitle_prefix => 'Random color between ',
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
        subtitle_prefix => 'Mix ',
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

sub reverse_color {
    my %cap = @_;
    my $c = normalize_color($cap{c});
    my $color = normalize_color_for_template(reverse_rgb_color($c));
    return (
        data => {
            subtitle_prefix => '(RGB) Opposite color of ',
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

    my %cap;
    my $form = first {
        my $match = $query =~ $_;
        %cap = %+;
        $match;
    } @query_forms or return;
    return unless remainder_probably_relevant($form, $query);
    my $action = $query_forms{$form};
    $cap{query} = $query;
    my %result = normalize_result($action->(%cap)) or return;

    return $result{text_answer},
        structured_answer => {

            data => $result{data},

            templates => {
                group   => "text",
                options => {
                    title_content    => 'DDH.rgb_color.title_content',
                    subtitle_content => 'DDH.rgb_color.sub_list',
                },
            }
        };
};

1;
