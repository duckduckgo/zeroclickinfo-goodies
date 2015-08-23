package DDG::Goodie::IsAwesome::alexander95015;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_alexander95015";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome alexander95015";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/alexander95015.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers any => "duckduckhack alexander95015";

# Handle statement
handle remainder => sub {

    # optional - regex guard
    # return unless qr/^\w+/;
    return if $_;
    return "alexander95015 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";

};

1;
