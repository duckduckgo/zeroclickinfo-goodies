package DDG::Goodie::Capitalize;

use DDG::Goodie;
use utf8;

zci is_cached => 1;
zci answer_type => "capitalize";
triggers startend => 'capitalize', 'uppercase';

handle remainder => sub { uc ($_) };

1;
