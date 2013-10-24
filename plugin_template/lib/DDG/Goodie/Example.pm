package DDG::Goodie::$ia_name;
# ABSTRACT: Write and abstract here
# Start at https://dukgo.com/duckduckhack/goodie_overview if you are new
# to plugin development
use DDG::Goodie;

#Attribution
primary_example_queries "Provide an primary example query";
secondary_example_queries "Provide an second example query";
description "Write an absolutely dazzling explaination of what this plugin does";
name "$ia_name";
icon_url "";
source "";
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/$ia_name.pm";
category "";
topics "";
attribution github => ["https://github.com/", ""],
            twitter => ["https://twitter.com/", ""];

# Triggers
# Example Word Trigger
triggers any => 'example';

# Handle statement
handle remainder => sub {
};

1;
