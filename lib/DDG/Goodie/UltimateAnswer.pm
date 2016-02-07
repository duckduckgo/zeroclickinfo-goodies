package DDG::Goodie::UltimateAnswer;
# ABSTRACT: A Hitchhiker's Guide to the Galaxy easter egg.

use strict;
use DDG::Goodie;

triggers end =>
    'meaning of life the universe and everything',
    'answer to life the universe and everything',
    'ultimate answer to life the universe and everything',
    'answer to the question of life the universe and everything',
    'answer to the ultimate question of life the universe and everything',
    'ultimate answer',
    'answer to the ultimate question';

zci answer_type => 'ultimate_answer';
zci is_cached   => 1;

handle remainder => sub {
    
    return unless $_ =~ qr/^(what is )?(the)?$/i;

    my $answer = 'Forty-two';

    return $answer,
        structured_answer => {
            id        => 'ultimate_answer',
            name      => 'Answer',
            data      => {
                title      => $answer,
                subtitle   => 'The Answer to the Ultimate Question of Life, the Universe, and Everything.'
            },
            meta      => {
                sourceName => 'Wikipedia',
                sourceUrl  => 'https://en.wikipedia.org/wiki/Phrases_from_The_Hitchhiker%27s_Guide_to_the_Galaxy#Answer_to_the_Ultimate_Question_of_Life.2C_the_Universe.2C_and_Everything_.2842.29'
            },
            templates => {
                group      => 'text'
            }
    };
};

1;
