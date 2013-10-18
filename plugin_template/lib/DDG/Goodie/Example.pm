package DDG::Goodie::$plugin_name.pm;
# ABSTRACT: Write and abstract here

use DDG::Goodie;
use URI::Escape;

#Attribution
primary_example_queries "Provide an second example query";
secondary_example_queries "Provide an second example query";
description "Write an absolutely dazzling explaination of what this plugin does";
name "$plugin_name";
icon_url "";
source "";
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/$plugin_name.pm";
category "";
topics "";
attribution github => ["https://github.com/", ""],
            twitter => ["https://twitter.com/", ""];

# Triggers

triggers query_lc => qr//;


# Handle statement
handle query_lc => sub {
};

1;
