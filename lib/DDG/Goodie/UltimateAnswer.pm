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

handle query => sub {
    
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
        input     => [],
        operation => 'The answer to the ultimate question of life, the universe and everything',
        result    => $answer
      };
};

1;
