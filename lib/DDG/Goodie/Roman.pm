package DDG::Goodie::Roman;
# ABSTRACT: Convert between Roman and Arabic numeral systems.

use strict;
use DDG::Goodie;

use Roman;
use List::Util qw/any/;
use utf8;

triggers startend => "roman", "roman numeral", "roman numerals", "roman number", 
                     "arabic", "arabic numeral", "arabic numerals", "arabic number";

zci is_cached => 1;
zci answer_type => "roman_numeral_conversion";

# These two lists are used to load the converter without any answer.
my @roman_to_arabic = (
    qr/^convert\s+(?:into|to)\s+arabic\s*(numerals?)?$/i
);
my @arabic_to_roman = (
    qr/^convert\s+(?:into|to)\s+roman\s*(numerals?)?$/i
);
 
# These two lists are used to load the converter with an answer. 
my @roman_number_to_arabic = (
    qr/^convert\s+(\D+)\s+(?:into|in|to)\s*arabic\s*(numerals?)?$/i,
    qr/^roman\s+(?:numerals?)?\s*(\D+)$/i,
    qr/^arabic\s+(?:numerals?)?\s*(\D+)$/i,
    qr/^([ivxlcdm]+)\s+(?:into|in|to)?\s+arabic\s*(numerals?)?$/i
);    
my @arabic_number_to_roman = (
    qr/^convert\s+(\d+)\s+(?:into|in|to)\s*roman\s*(numerals?)?$/i,
    qr/^roman\s+(?:numerals?)?\s*(\d+)$/i,
    qr/^arabic\s+(?:numerals?)?\s*(\d+)$/i,
    qr/^(\d+)\s+(?:into|in|to)?\s+roman\s*(numerals?)?$/i
);

handle query => sub {
    my ($query) = @_;

    # By default, we convert from roman to arabic.
    my $input = 'roman';
    my $input_value = '';
    my $output = 'arabic';
    my $output_value = '';
    
    if (any { $query =~ $_ } @arabic_to_roman) {
        $input = 'arabic';
        $output = 'roman';
    } elsif (any { ($input_value) = $query =~ $_ } @roman_number_to_arabic) {
        if (isroman $input_value) {
            $input_value = uc $input_value;
            $output_value = arabic $input_value;
        } else {
            # Malformed input (not a roman number), we don't trigger the ia.
            return;
        }
    } elsif (any { ($input_value) = $query =~ $_ } @arabic_number_to_roman) {
        $input = 'arabic';
        $output = 'roman';
        $input_value = $input_value;
        $output_value = Roman $input_value;
    } else {
        $input_value = ''; # because of previous assignments with undef.
        return unless any { $query =~ $_ } @roman_to_arabic;
    }

    return 'roman numeral converter', structured_answer => {
        data => {
            subtitle => 'Accepts inputs from 1 - 3999, I - MMMCMXCIX',
            input => $input,
            input_value => $input_value,
            output => $output,
            output_value => $output_value
        },
        templates => {
            group => 'text',
            options => {
                title_content => 'DDH.roman.content',
            }
        }    
    };
};

1;
