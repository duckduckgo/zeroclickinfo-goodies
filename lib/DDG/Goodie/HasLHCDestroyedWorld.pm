package DDG::Goodie::HasLHCDestroyedWorld;

# ABSTRACT: Has the Large Hadron Collider destroyed the world yet? Nope.

use DDG::Goodie;
use strict;

zci answer_type => 'has_lhcdestroyed_world';
zci is_cached => 1;

triggers start => 'has the large hadron collider destroyed the world',
                'has the lhc destroyed the world',
                'has the large hadron collider destroyed the earth',
                'has the lhc destroyed the earth';

# Handle statement
handle remainder => sub {
    return unless /^(yet)?$/;
    return "Nope.",
        structured_answer => {
            id => 'has_lhcdestroyed_world',
            name => 'Answer',
            data => {
                title => "Has it?",
                subtitle => "Nope."
            },
            meta => {
                sourceName => "Has the Large Hadron Collider destroyed the world yet?",
                sourceUrl => "http://hasthelargehadroncolliderdestroyedtheworldyet.com/"
            },
            templates => {
                group => "text",
                moreAt => 1
            }
        };
};

1;
