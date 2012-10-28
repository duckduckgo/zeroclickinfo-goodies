package DDG::Goodie::Rafl;
# ABSTRACT: rafl is so everywhere, there's a DuckDuckGo.com "!rafl" bang syntax
use DDG::Goodie;

use Acme::rafl::Everywhere;

triggers any => 'rafl';

handle remainder => sub {
  return Acme::rafl::Everywhere->new->fact
};

1 && "rafl"; # everywhere
