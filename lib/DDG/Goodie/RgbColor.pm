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

triggers any => 'color';

my $color_re = 'color';

my %query_forms = (
    "random $color_re" => \&random_color,
);
my @query_forms = keys %query_forms;

sub random_color {
    srand;
    my %data = (
        subtitle => 'Random color',
    );
    my %result;
    my $color = rand_rgb_color();
    $data{title} = "$color";
    $result{text_answer}  = "$color";
    $result{data} = \%data;
    return %result;
}

handle query_lc => sub {
    my $query = $_;

    my $form = first { $query =~ qr/$_/ } @query_forms;
    my $action = $query_forms{$form};
    my %result = $action->();

    return $result{text_answer},
        structured_answer => {

            data => $result{data},

            templates => {
                group => "text",
            }
        };
};

1;
