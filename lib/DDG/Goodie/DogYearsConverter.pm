package DDG::Goodie::DogYearsConverter;
# ABSTRACT: Simple converter from dog years to human years or vice versa

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'dog_years_converter';

zci is_cached => 1;

triggers end => 'dog years';

sub dog2human {
    return $_/7;
}

sub human2dog {
    return $_*7;
}

handle remainder => sub {
    my ($input, $from, $to, $result);

    #From dog years to human years
    if (/^([\d]+)(((\s)|(\s+(years|year))|(\s+human+\s+(years|year)+\s))+from)?$/) {
        $input = $1;
        $from = "Dog Years";
        $to = "Human Years";
        $result = dog2human($1);
    #From human years to dog years
    } elsif (/^([\d]+)(((\s)|(\s+(years|year)+\s)|(\s+human+\s+(years|year)+\s))+(in|to|into|as))?$/) {
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
