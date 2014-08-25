package DDG::Goodie::PigLatin;
# ABSTRACT: convert a given string to pig latin

use DDG::Goodie;
use Lingua::PigLatin 'piglatin';

triggers startend => 'pig latin', 'piglatin';

zci is_cached => 1;
zci answer_type => "translation";

attribution github => ['http://github.com/nospampleasemam', 'nospampleasemam'],
            web => ['http://github.com/nospampleasemam', 'nospampleasemam'];

primary_example_queries 'pig latin i love duckduckgo';
name 'PigLatin';
description 'translate a phrase into pig latin';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PigLatin.pm';
category 'conversions';
topics 'words_and_games';

handle remainder => sub {
    return "Pig Latin: " . piglatin($_)
};

1;
