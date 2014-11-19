package DDG::Goodie::HexToDec;
# ABSTRACT: Convert hexidecimal to decimal

use DDG::Goodie;
use Math::BigInt;

triggers query_raw => qr/^\s*0x[0-9a-fA-F]+\s*$/;

zci answer_type => 'hex_to_dec';
zci is_cached   => 1;

primary_example_queries '0x44696f21';
description 'convert hexidecimal to decimal';
name 'HexToDec';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/HexToDec.pm';
category 'conversions';
topics 'math', 'programming';
attribution cpan   => 'majuscule',
            github => 'nospampleasemam',
            web    => ['https://dylansserver.com', 'Dylan Lloyd'] ;

handle query_raw => sub {
    return unless (m/0x([0-9a-fA-F]+)/);

    my $hex     = $1;
    my $decimal = Math::BigInt->from_hex($hex);

    return "$hex base 16 = $decimal base 10", structured_answer => {
        input     => ['0x' . $hex],
        operation => 'hex to decimal',
        result    => "$decimal",         # Quoted for display precision as string.
    };
};

0x41414141;
