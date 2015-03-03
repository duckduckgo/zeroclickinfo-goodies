package DDG::Goodie::2048;
# ABSTRACT: Write an abstract here

use DDG::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

name "2048";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/2048.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers any => "2048 game", "play 2048";

# Handle statement
handle remainder => sub {

	#return unless $_; # Guard against "no answer"

	my $html = scalar share('2048.html')->slurp;

	return html => $html;
};

1;
