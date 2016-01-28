package DDG::Goodie::UltimateAnswer;
# ABSTRACT: A Hitchhiker's Guide to the Galaxy easter egg.

use strict;
use DDG::Goodie;

triggers any =>
    'life the universe and everything',
    'ultimate answer',
    'answer to the ultimate question';

zci answer_type => 'ultimate_answer';
zci is_cached   => 1;

handle query_lc => sub {
    
    return if (
        # 'life the universe and everything' is the name of a book in the series.
        # Want to restrict this query a bit.
        (
            $_ =~ /life the universe and everything/ &&
            !($_ =~ /question|answer|what is|meaning/)
        ) ||
        # 'ultimate answer' can refer to other topics (e.g. 'ultimate answer to kings')
        # Also want to restrict this query.
        (
            $_ =~ /ultimate answer/ &&
            !( $_ =~ /^(what is the )?ultimate answer(\?)?$/) &&
            !( $_ =~ /life the universe and everything/ )
        ) ||
        # Restrict 'answer to the ultimate question' just to be safe
        (
            $_ =~ /answer to the ultimate question/ &&
            !( $_ =~ /^((what is the )?(ultimate )?answer to the ultimate question(\?)?)$/) &&
            !( $_ =~ /life the universe and everything/)
        )
    );

    my $answer = 'Forty-two';

    return $answer,
        structured_answer => {
            id        => 'ultimate_answer',
            name      => 'Answer',
            data      => {
                title      => $answer,
                subtitle   => 'The answer to the ultimate question of life, the universe and everything.'
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
