package DDG::Goodie::RgbColor;

use DDG::Goodie;
use strict;
use warnings;

use List::Util qw(first);
use Color::RGB::Util qw(
    rand_rgb_color
);

zci answer_type => 'rgb_color';

zci is_cached => 0;

triggers any => 'color', 'colour';

my $scolor = 'colou?r';

#############
#  Helpers  #
#############

sub normalize_color {
    my $color = shift;
    return $color if $color =~ /^#/;
    return "#$color";
}

####################
#  Query Handlers  #
####################

my %query_forms = (
    "rand(om)? $scolor" => \&random_color,
);
my @query_forms = keys %query_forms;

sub random_color {
    srand;
    my %data = (
        subtitle => 'Random color',
    );
    my %result;
    my $color = normalize_color(rand_rgb_color());
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

    my $form = first { $query =~ qr/$_/ } @query_forms or return;
    my $action = $query_forms{$form};
    my %result = normalize_result($action->());

    return $result{text_answer},
        structured_answer => {

            data => $result{data},

            templates => {
                group   => "text",
                options => {
                    title_content    => 'DDH.rgb_color.title_content',
                },
            }
        };
};

1;
