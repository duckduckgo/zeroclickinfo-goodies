package DDG::Goodie::RgbColor;

use DDG::Goodie;
use strict;
use warnings;

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

    my %result;
    while (my ($form, $action) = each %query_forms) {
        if ($query =~ qr/$form/) {
            %result = $action->();
            last;
        }
    }

    return $result{text_answer},
        structured_answer => {

            data => $result{data},

            templates => {
                group => "text",
            }
        };
};

1;
