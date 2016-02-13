package DDG::Goodie::PigLatin;
# ABSTRACT: convert a given string to pig latin

use strict;
use DDG::Goodie;
use Lingua::PigLatin 'piglatin';

triggers startend => 'pig latin', 'piglatin';

zci answer_type => "translation";
zci is_cached   => 1;

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
