package DDG::Goodie::IsAwesome::JerbiAhmed;

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_jerbi_ahmed";
zci is_cached   => 0;


# Triggers
triggers start => "duckduckhack jerbiahmed";

# Handle statement
handle remainder => sub {
    return if $_;
    return "Jerbi is Awesome yup yup";
};

1;