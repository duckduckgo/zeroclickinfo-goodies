package DDG::Goodie::ExampleDate;

# ABSTRACT: Generate random dates from given formats.

use DDG::Goodie;
use strict;

use DateTime;

zci answer_type => 'example_date';

zci is_cached => 0;

triggers any   => 'date';

handle query => sub {
    my $query = shift;
    return unless $query =~ /^((random|example) )?date for (?<format>.+)$/i;
    my $format = $+{'format'};
    my $random_date = get_random_date();
    my $formatted = $random_date->strftime($format);

    return if $formatted eq $format;

    return "$formatted",
        structured_answer => {

            data => {
              title => "$formatted",
              subtitle => "Random date for: $format",
            },

            templates => {
                group => "text",
            }
        };
};

sub get_random_date {
    my $rand_num = int(rand(1_000_000_000));
    return DateTime->from_epoch(epoch => $rand_num);
}

1;
