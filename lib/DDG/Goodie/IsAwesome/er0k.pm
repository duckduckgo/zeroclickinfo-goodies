package DDG::Goodie::IsAwesome::er0k;
# ABSTRACT: er0k's goodie

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_er0k";
zci is_cached   => 1;

# Metadata
name "IsAwesome er0k";
description "doin tutorials yup";
primary_example_queries "duckduckhack er0k";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/er0k.pm";
attribution github => ["https://github.com/er0k", "er0k"],
            twitter => "";

# Triggers
triggers any => "duckduckhack er0k";

# Handle statement
handle remainder => sub {
    return if $_;
    return ":)";
};

1;
