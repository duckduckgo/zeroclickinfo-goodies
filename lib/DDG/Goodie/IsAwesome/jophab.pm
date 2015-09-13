package DDG::Goodie::IsAwesome::jophab;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_jophab";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome jophab";
description "My first Goodie, it let's the world know that jophab is awesome";
primary_example_queries "duckduckhack jophab";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
category "special";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
 topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/jophab.pm";
attribution github => ["https://github.com/jophab", "jpa"];

# Triggers
triggers start => "duckduckhack jophab";

# Handle statement
handle remainder => sub {
    return if $_;
    return "GitHubUsername is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
