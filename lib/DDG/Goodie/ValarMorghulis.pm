package DDG::Goodie::ValarMorghulis;
# ABSTRACT: A Game of Thrones / A Song of Ice and Fire easter egg.

use strict;
use utf8;
use DDG::Goodie;

triggers start => 'valar morghulis';

zci answer_type => 'valar_morghulis';
zci is_cached   => 1;

handle remainder => sub {
    return unless ($_ eq '');

    my $answer = 'Valar dohaeris';

    return $answer,
      structured_answer => {
        data => {
            title    => $answer,
            subtitle => 'Code phrase: Valar morghulis'
        },
        templates => {
            group => 'text'
        }
      };
};

1;
