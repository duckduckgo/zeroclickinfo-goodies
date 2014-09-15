package DDG::Goodie::<: $ia_name :>;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

#Attribution
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
description "Succinct explanation of what this instant answer does";
name "<: $ia_name :>";
icon_url "";
source "";
code_url "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Spice/<: $ia_name :>.pm";
category "";
topics "";
attribution github => ["https://github.com/", ""],
            twitter => ["https://twitter.com/", ""];

# Triggers
triggers any => "triggerWord", "trigger phrase";

# Handle statement
handle remainder => sub {

	# optional - regex guard
	# return unless qr/^\w+/;

	return $_ if $_;
	return;
};

1;
