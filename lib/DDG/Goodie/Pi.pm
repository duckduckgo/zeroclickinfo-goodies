# ABSTRACT: This Goodie returns 'pi' to a user-specified number of decimal places

use DDG::Goodie;
use Math::Trig;

zci answer_type => "pi";
zci is_cached   => 1;

name "Pi";
primary_example_queries "pi 7";
description "Ex. returns 3.1415926";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Pi.pm";
attribution github => ["https://github.com/jmvbxx", "jmvbxx"];

# Triggers
triggers any => "pi";

# Handle statement
handle remainder => sub {

    my $decimal = $_;
    my $answer = substr pi, 0, ( $decimal + 2 );
    
    return "$answer";
    
};

1;
