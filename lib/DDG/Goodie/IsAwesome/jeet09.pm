package DDG::Goodie::IsAwesome::jeet09;
# ABSTRACT: Jitu's first Goodie
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_jeet09";
zci is_cached   => 1;

# Triggers
triggers start => "duckduckhack jeet09", "jeet09 duckduckhack";

# Handle statement
handle remainder => sub {
    return if $_;
    return "Jitu is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};
1;
