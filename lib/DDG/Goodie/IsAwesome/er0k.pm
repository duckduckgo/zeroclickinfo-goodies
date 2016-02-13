package DDG::Goodie::IsAwesome::er0k;
# ABSTRACT: er0k's goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_er0k";
zci is_cached   => 1;

# Triggers
triggers any => "duckduckhack er0k";

# Handle statement
handle remainder => sub {
    return if $_;
    return ":)";
};

1;
