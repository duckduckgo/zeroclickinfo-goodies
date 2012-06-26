package DDG::Goodie::PigLatin;

use DDG::Goodie;
use Lingua::PigLatin 'piglatin';

triggers startend => 'pig latin', 'piglatin';

zci is_cached => 1;
zci answer_type => "translation";

handle remainder => sub { piglatin($_) };

1;
