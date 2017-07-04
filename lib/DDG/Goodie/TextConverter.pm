package DDG::Goodie::TextConverter;
# ABSTRACT: Write an abstract here

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'text_converter';
zci is_cached => 0;

# Triggers
triggers any => 'text converter';

handle query => sub {

    my $query = $_;

    return 'plain text response',
        structured_answer => {

            data => {
                title    => "Text Converter",
                subtitle => "Various Text Conversion Tools",
            },
            templates => {
                group => 'text',
            }
        };
};

1;
