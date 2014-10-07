package DDG::Goodie::UltimateAnswer;
# ABSTRACT: A Hitchhiker's Guide to the Galaxy easter egg.

use DDG::Goodie;
triggers start => 'what is the ultimate answer', 'what is the ultimate answer to life the universe and everything', 'what is the answer to the ultimate question of life the universe and everything';

primary_example_queries 'what is the answer to the ultimate question of life the universe and everything';

name 'Ultimate Answer';
description 'Hichhiker\'s Guide to the Galaxy reference.';
category 'special';
topics 'entertainment';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/UltimateAnswer.pm';
attribution github  => ['https://github.com/jfeeneywm/', 'jfeeneywm'],
            twitter => ['https://twitter.com/jfeeneywm', 'jfeeneywm'];

zci answer_type => 'ultimate_answer';
zci is_cached   => 1;

handle remainder => sub {
    return unless ($_ eq '' || $_ eq '?');

    my $answer = 'Forty-two';

    return $answer,
      structured_answer => {
        input     => [],
        operation => 'the answer to the ultimate question of life, the universe and everything',
        result    => $answer
      };
};

1;
