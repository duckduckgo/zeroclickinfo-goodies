package DDG::Goodie::Capitalize;

use DDG::Goodie;
use utf8;

zci is_cached => 1;

triggers startend => 'capitalize', 'uppercase';

handle remainder => sub { uc ($_) };

1;
