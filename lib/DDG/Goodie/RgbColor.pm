package DDG::Goodie::RgbColor;

use DDG::Goodie;
use strict;
use warnings;

use List::Util qw(first);
use Color::Library;
use Color::RGB::Util qw(
    mix_2_rgb_colors
    rand_rgb_color
);

zci answer_type => 'rgb_color';

zci is_cached => 0;

triggers any => 'color', 'colour';
triggers start => 'mix';

#####################
#  Color Constants  #
#####################

my %colors = map { $_ => '#' . lc Color::Library->color($_)->hex }
    Color::Library->WWW->names;
my @color_names = sort keys %colors;
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

####################
#  Query Handlers  #
####################

my %query_forms = (
    "rand(om)? $scolor( between (?<c1>$color_re)( and)? " .
        "(?<c2>$color_re))?" => \&random_color,
    "mix (?<c1>$color_re)( and)? (?<c2>$color_re)" => \&mix_colors,
);
my @query_forms = keys %query_forms;

sub random_color {
    my %cap = @_;
    srand;
    my $c1 = normalize_color($cap{c1} // '#000000');
    my $c2 = normalize_color($cap{c2} // '#ffffff');
    my %data = (
        subtitle_prefix => 'Random color between ',
        input_colors => [$c1, $c2],
    );
    my %result;
    my $color = normalize_color(rand_rgb_color($c1, $c2));
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
        input_colors => [$c1, $c2],
    );
    my %result;
    my $color = normalize_color(mix_2_rgb_colors($c1, $c2));
    $data{result_color} = $color;
    $result{data} = \%data;
    return %result;
}

sub normalize_result {
    my %result = @_;
    $result{text_answer} = $result{data}->{result_color};
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
    my %result = normalize_result($action->(%cap));

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
