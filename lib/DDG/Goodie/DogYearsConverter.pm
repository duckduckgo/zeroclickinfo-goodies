package DDG::Goodie::DogYearsConverter;
# ABSTRACT: Simple converter from dog years to human years or vice versa

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'dog_years_converter';

zci is_cached => 1;

triggers end => 'dog years';

sub dog2human {
    return (shift)/7;
}

sub human2dog {
    return (shift)*7;
}

handle remainder => sub {
    my ($input, $from, $to, $result);

    if (/(\d+)( (human )?(year[s]?)? ?from)/) {
        $input = $1;
        $from = "Dog Years";
        $to = "Human Years";
        $result = dog2human($1);
    } elsif (/(\d+)( (human )?(year[s]?)? ?(to|into|in|as))/) {
        $input = $1;
        $from = "Human Years";
        $to = "Dog Years";
        $result = human2dog($1);
    }
    return unless ($input);    # Didn't hit any conditions.

    return qq/Dog Year Conversion: $input ($from) = $result ($to)/,
        structured_answer => {
            data => {
              title => $result,
              subtitle =>$from . ' to ' . $to . ': ' . $input
            },
            templates => {
              group => 'text'
            }
        };

};

1;
