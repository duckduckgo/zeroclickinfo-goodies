package DDG::Goodie::Hodor;
# ABSTRACT: Returns "Hodor"

use DDG::Goodie;
use strict;

zci answer_type => "hodor";
zci is_cached   => 1;


name "Hodor";
description "Returns hodor when you type it in. ";
primary_example_queries "hodor";
category "special";
topics "geek", "special_interest";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Hodor.pm";
attribution github => ["javathunderman", "Thomas Denizou"],
            twitter => "javathunderman";


triggers any => "hodor";

my $hodor = share('hodor.txt')->slurp;


handle remainder => sub {

    
    return $hodor;
    return unless $_;

    return $_;
};

1;
