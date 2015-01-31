package DDG::Goodie::Ascii;
# ABSTRACT: ASCII

use DDG::Goodie;

triggers end => "ascii";

primary_example_queries '0110100001100101011011000110110001101111 to ascii';
description 'convert binary data to readable characters';
name 'Ascii';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Binary.pm';
category 'transformations';
topics 'cryptography';

zci answer_type => "ascii_conversion";
zci is_cached   => 1;

handle remainder => sub {
    my $ascii = pack("B*", $1) if /^(([0-1]{8})*)\s+(in|to)$/;
    my $binary = $1;

    return unless $ascii;

    return "$binary in binary is \"$ascii\" in ASCII",
      structured_answer => {
        input     => [$binary],
        operation => 'Binary to ASCII',
        result    => html_enc($ascii),
      };
};

1;

