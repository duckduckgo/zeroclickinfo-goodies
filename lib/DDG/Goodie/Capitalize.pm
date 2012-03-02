package DDG::Goodie::Capitalize;

use DDG::Goodie;
use utf8;

triggers start => 'capitalize', 'uppercase';

handle remainder => sub { uc($_) };
1;
