package DDG::Goodie::Capitalize;

use DDG::Goodie;

triggers startend => 'capitalize', 'uppercase', 'upper case';

zci is_cached => 1;
zci answer_type => "capitalize";

handle remainder => sub { uc ($_) };

1;
