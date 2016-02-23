package DDG::Goodie::UltimateAnswer;
# ABSTRACT: A Hitchhiker's Guide to the Galaxy easter egg.

use strict;
use DDG::Goodie;
triggers start => 'what is the ultimate answer', 'what is the ultimate answer to life the universe and everything', 'what is the answer to the ultimate question of life the universe and everything';

zci answer_type => 'ultimate_answer';
zci is_cached   => 1;

handle remainder => sub {
    return unless ($_ eq '' || $_ eq '?');

    my $answer = 'Forty-two';

    return $answer,
      structured_answer => {
        input     => [],
        operation => 'The answer to the ultimate question of life, the universe and everything',
        result    => $answer
      };
};

1;
