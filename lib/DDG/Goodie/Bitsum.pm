package DDG::Goodie::Bitsum;
# ABSTRACT: Computes the Hamming weight of a hex or decimal number.

use DDG::Goodie;
use strict;

use Math::BigInt;

zci answer_type => "bitsum";
zci is_cached   => 1;

# Triggers
triggers start => "bitsum", "hammingweight", "hw", 
                  "bitsum of", "hammingweight of", "hw of",
                  "bitsum for", "hammingweight for", "hw for";

# Handle statement
handle remainder => sub {
    
    # Return if input is no hex or decimal number
    return unless $_ =~ /(^0x[0-9a-f]+$)|(^0b[0-1]+$)|(^\d+$)/i;

    my $input_number = $_;
    my $hex_number;
    my $binstring;
    my $base;
    my $base_string;

    # Construct binary representation for both hex and decimal numbers
    if( $input_number =~ /^0x/) {
        $hex_number = substr($input_number, 2);
        $binstring = unpack ('B*', pack ('H*',$hex_number));
        $base = 16;
        $base_string = 'Hexadecimal';
    } elsif( $input_number =~ /^0b/) {
        $binstring = substr($input_number, 2);
        $base = 2;
        $base_string = 'Binary';
    } else {
        $binstring = Math::BigInt->new($input_number)->as_bin();
        $base = 10;
        $base_string = 'Decimal';
    }
    
    # Count ones
    my $result = $binstring =~ tr/1/1/;
    $input_number .= ' (Base '.$base.', '.$base_string.')';

    return $result,
        structured_answer => {
            input     => [html_enc($input_number)],
            operation => 'Hamming Weight Calculation',
            result    => html_enc($result),
        };
};


1;
