package DDG::Goodie::Meta;
# ABSTRACT: Goodie that should never trigger

use strict;
use DDG::Goodie;

triggers start => "///***never trigger***///";

1;
