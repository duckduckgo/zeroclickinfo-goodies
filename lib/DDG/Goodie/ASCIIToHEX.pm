package DDG::Goodie::ASCIIToHEX;
# ABSTRACT: Convert a given ASCII string to Hexadecimal

use DDG::Goodie;
use strict;

zci answer_type => 'ascii_to_hex';
zci is_cached => 1;

triggers startend => 'ascii to hex', 'convert ascii hex', 'ascii hex conversion', 'convert ascii to hex', 'ascii hex';

handle remainder => sub {
    
    my $original_string = $_;
    my $result = unpack('H*', $original_string);
    
    # Separates the numbers into sets of two
    $result =~ s/..\K(?=.)/ /sg;
    
    return "$original_string converts to $result",
        structured_answer => {
            input       => [$original_string],
            operation   => 'ASCII to HEX',
            result      => $result
        };
};

1;
