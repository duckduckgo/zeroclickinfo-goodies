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

zci answer_type => 'rgb_color';

zci is_cached => 0;

my @opposite_words = ('opposite', 'complement', 'complementary');
triggers any => 'color', 'colour', 'mix', @opposite_words;

#####################
#  Color Constants  #
#####################

my %colors = map { $_ => '#' . lc Color::Library->color($_)->hex }
    Color::Library->WWW->names;

my @color_names = sort keys %colors;
my %hex_to_name = map { $colors{$_} => $_ } @color_names;
my $color_name_re = '(?:' . (join '|', @color_names) . ')';

my $scolor = 'colou?r';
my $color_re = "(?:$color_name_re|#?\\p{XDigit}{6})";

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
    return $hex_to_name{$_[0]} // '';
}

sub normalize_colors_for_template {
    my @colors = @_;
    map { {
        hex  => $_,
        name => common_name($_),
    } } map { normalize_color($_) } @colors;
}

sub normalize_color_for_template {
    my @colors = normalize_colors_for_template(@_);
    return $colors[0];
}

sub probably_relevant {
    my $text = shift;
    return 1 if $text =~ /$scolor/;
    return 0;
}

####################
#  Query Handlers  #
####################

my $reverse_re = "(opposite|complement(ary)?)( $scolor)?( (of|to|for))?";

my %query_cat = (
    random => "rand(om)? $scolor( between (?<c1>$color_re)( and)? " .
                "(?<c2>$color_re))?\$",
    mix => "mix (?<c1>$color_re)( and)? (?<c2>$color_re)",
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
    my $c1 = normalize_color($cap{c1} // '#000000');
    my $c2 = normalize_color($cap{c2} // '#ffffff');
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

my $rev_form = $query_cat{reverse};
sub reverse_color {
    my %cap = @_;
    my $c = normalize_color($cap{c});
    my $color = normalize_color_for_template(reverse_rgb_color($c));
    if ($cap{query} =~ /$rev_form(?<remr>.+)/) {
        return unless probably_relevant($+{remr});
    }
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
