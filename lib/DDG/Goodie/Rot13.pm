package DDG::Goodie::Rot13;
# ABSTRACT: Rotate chars by 13  letters

use DDG::Goodie;

primary_example_queries 'rot13 thirteen';
secondary_example_queries 'rot13 guvegrra';
description 'rotate all the letters in your query by 13';
name 'Rot13';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Rot13.pm';
category 'transformations';
topics 'cryptography';

attribution github => ['https://github.com/unlisted', 'unlisted'];

triggers start => 'rot13';

zci is_cached => 1;

handle remainder => sub {
    if ($_) {
        $_ =~ tr[a-zA-Z][n-za-mN-ZA-M]; 
        return "ROT13: $_";
    };
    return;
};

1;
