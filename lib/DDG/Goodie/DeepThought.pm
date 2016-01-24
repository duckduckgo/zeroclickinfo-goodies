package DDG::Goodie::DeepThought;

# ABSTRACT: Returns '42' as 'The Answer to the Ultimate Question of Life, The Universe, and Everything' (from 'The Hitchhiker's Guide to the Galaxy')

use DDG::Goodie;
use strict;

zci answer_type => 'deep_thought';

zci is_cached => 1;

triggers any => 'life the universe and everything';

# Handle statement
handle remainder => sub {

    my $remainder = $_;

    # This avoids returning an answer for just 'life the universe and everything', which is in fact a book in the series.
    return unless $remainder =~ /answer|question/;

    return 42,
      structured_answer => {
        input     => [],
        operation => 'The Answer to the Ultimate Question of Life, The Universe, and Everything',
        result    => 42
      };

};

1;
