package DDG::Goodie::Unidecode;
# ABSTRACT: return an ASCII version of the search query

use DDG::Goodie;
use Text::Unidecode;

zci is_cached => 1;
zci answer_type => "convert to ascii";
triggers startend => "unidecode";

handle remainder => sub {
    my $u = unidecode $_;
    # unidecode output sometimes contains trailing spaces
    $u =~ s/\s+$//;
    return $u;
};

1;
