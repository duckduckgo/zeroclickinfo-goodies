package DDG::Goodie::RgbColor;

use DDG::Goodie;
use strict;
use warnings;

use List::Util qw(first);
use Color::Library;
use Color::RGB::Util qw(
    mix_2_rgb_colors
    rand_rgb_color
    reverse_rgb_color
);
use Lingua::StopWords qw(getStopWords);
use Lingua::EN::StopWords qw(%StopWords);

zci answer_type => 'rgb_color';

zci is_cached => 0;

my @opposite_words = ('opposite', 'complement', 'complementary');
my @color_words = map { $_, "${_}s" } ('color', 'colour');
my @mix_words = ('mix', 'mixed');
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
my $color_re = "(?:$color_name_re|#?\\p{XDigit}{6})";

my %stops = (%StopWords, %{getStopWords('en')});
my @stopwords = keys %stops;
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
    my @colors = @_;
    map { ref $_ eq 'Color::Library::Color' ? {
        hex  => $_->html,
        name => $_->name,
    } : { hex => $_, name => common_name($_) } } map { normalize_color($_) } @colors;
}

sub normalize_color_for_template {
    my @colors = normalize_colors_for_template(@_);
    return $colors[0];
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

my $mix_re = 'mix(ed)?';
my $reverse_re = "(opposite|complement(ary)?)( $scolor)?( (of|to|for))?";

my $dual_colors_re = "(?<c1>$color_re)( and)? (?<c2>$color_re)";

my %query_cat = (
    random => "rand(om)? $scolor( between $dual_colors_re)?\$",
    mix => "$mix_re $dual_colors_re|$dual_colors_re $mix_re",
    reverse => "$reverse_re (?<c>$color_re)",
);
my %query_forms = (
    $query_cat{mix}     => \&mix_colors,
    $query_cat{random}  => \&random_color,
    $query_cat{reverse} => \&reverse_color,
);

my @query_forms = keys %query_forms;

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
    my $c1 = normalize_color($caps{c1});
    my $c2 = normalize_color($caps{c2});
    my %data = (
        subtitle_prefix => 'Mix ',
        input_colors => [normalize_colors_for_template($c1, $c2)],
    );
    my %result;
    my $color = normalize_color_for_template(mix_2_rgb_colors($c1, $c2));
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
        my $match = $query =~ qr/$_/;
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
