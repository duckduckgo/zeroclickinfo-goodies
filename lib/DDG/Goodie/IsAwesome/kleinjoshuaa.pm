package DDG::Goodie::IsAwesome::kleinjoshuaa;
# ABSTRACT: kleinjoshuaa's first goodie


use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_kleinjoshuaa";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack kleinjoshuaa";

# Handle statement
handle remainder => sub {
    return if $_;
    return "kleinjoshuaa is awesome and has successfully completed the duckduckhack goodie tutorial!";
};

1;
