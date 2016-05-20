package DDG::Goodie::Rafl;
# ABSTRACT: rafl is so everywhere, there's a DuckDuckGo.com "!rafl" bang syntax

use strict;
use DDG::Goodie;

use Acme::rafl::Everywhere;

triggers any => 'rafl';

zci answer_type => 'rafl';
zci is_cached   => 1;

handle remainder => sub {
    my $fact = Acme::rafl::Everywhere->new->fact;

    return $fact, structured_answer => {
        data => {
            title => $fact
        }, 
        templates => {
            group => 'text'
        }
    };
};

1 && "rafl"; # everywhere
