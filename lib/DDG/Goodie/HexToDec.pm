package DDG::Goodie::HexToDec;
# ABSTRACT: Convert hexidecimal to decimal

use DDG::Goodie;
use bignum;

triggers query_raw => qr/\b0x[0-9a-fA-F]+\b/;

zci answer_type => "decimal";

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
    m/\b0x([0-9a-fA-F]+)\b/;
    sprintf "%lu", hex $1;
};

0x41414141;
