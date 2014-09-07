package DDG::Goodie::Rafl;
# ABSTRACT: rafl is so everywhere, there's a DuckDuckGo.com "!rafl" bang syntax

use DDG::Goodie;

use Acme::rafl::Everywhere;

primary_example_queries 'rafl is everywhere';
secondary_example_queries 'where is rafl?';
description 'rafl is everywhere!';
name 'rafl';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/.pm';
category 'ids';
topics 'social';

attribution
  web     => 'http://stephen.scaffidi.net',
  github  => ['https://github.com/Hercynium', 'Hercynium'];

triggers any => 'rafl';

handle remainder => sub {
  return Acme::rafl::Everywhere->new->fact
};

1 && "rafl"; # everywhere
