package DDG::Goodie::HexToDec;
# ABSTRACT: Convert hexidecimal to decimal

use strict;
use DDG::Goodie;
use Math::BigInt;

triggers query_raw => qr/^\s*0x[0-9a-fA-F]+(?:(?:\s+hex)?\s+(?:in|as|to)\s+(?:dec(?:imal)?|base(?:\s+|-)?10))?\s*$/;

zci answer_type => 'hex_to_dec';
zci is_cached   => 1;

handle query_raw => sub {
    return unless (m/0x([0-9a-fA-F]+)/);

    my $hex     = $1;
    my $decimal = Math::BigInt->from_hex($hex);

    return "$hex base 16 = $decimal base 10", structured_answer => {
        data => {
            title => "$decimal",         # Quoted for display precision as string.
            subtitle => "Hex to decimal: 0x" . $hex
        },
        templates => {
            group => 'text',
        }
    };
};

0x01;
