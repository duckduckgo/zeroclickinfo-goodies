package DDG::Goodie::PigLatin;
# ABSTRACT: convert a given string to pig latin

use DDG::Goodie;
use Lingua::PigLatin 'piglatin';

triggers startend => 'pig latin', 'piglatin';

zci answer_type => "translation";
zci is_cached   => 1;

attribution github => ['nospampleasemam', 'Dylan Lloyd'],
            web    => ['nospampleasemam', 'Dylan Lloyd'];

primary_example_queries 'pig latin i love duckduckgo';
name 'PigLatin';
description 'translate a phrase into pig latin';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PigLatin.pm';
category 'conversions';
topics 'words_and_games';

handle remainder => sub {
    my $in = shift;

    my $out = piglatin($in);

    return "Pig Latin: " . $out,
      structured_answer => {
        input     => [html_enc($in)],
        operation => 'Translate to Pig Latin',
        result    => html_enc($out)
      };
};

1;
