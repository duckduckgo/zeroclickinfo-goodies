package DDG::Goodie::IsAwesome::amolveer;
# ABSTRACT: Amol's first Goodie
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "is_awesome_amolveer";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome amolveer";
description "My first Goodie, it let's the world know that amolveer is awesome";
primary_example_queries "duckduckhack amolveer";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/amolveer.pm";
attribution github => ["https://github.com/amolveer", "amolveer"];
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/amolveer/amolveer.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers start => "duckduckhack amolveer";

# Handle statement
handle remainder => sub {
	return if $_;
	return "amolveer is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
