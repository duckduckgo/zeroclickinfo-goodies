package DDG::Goodie::Rot13;
# ABSTRACT: Rotate chars by 13  letters

use DDG::Goodie;

triggers start => 'rot13';

handle remainder => sub {
    if ($_)
    {
        $_ =~ tr[a-zA-Z][n-za-mN-ZA-M]; 
        return "ROT13: $_";
    };

    return;

};

zci is_cached => 1;

1;
