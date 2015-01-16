package DDG::Goodie::Unidecode;
# ABSTRACT: return an ASCII version of the search query

use DDG::Goodie;
use Text::Unidecode;
use utf8;

triggers startend => "unidecode";

zci is_cached => 1;
zci answer_type => "convert_to_ascii";

attribution github => ['moritz', 'Moritz Lenz'];
primary_example_queries 'unidecode møæp';
secondary_example_queries "unidecode åäº°";
description 'decode special non-latin characters';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Unidecode.pm';
category 'computing_tools';
topics 'programming';

handle remainder => sub {
    my $u = unidecode $_;
    # unidecode output sometimes contains trailing spaces
    $u =~ s/\s+$//;
    return $u;
};

1;
