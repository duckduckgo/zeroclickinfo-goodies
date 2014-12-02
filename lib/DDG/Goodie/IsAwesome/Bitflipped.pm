package DDG::Goodie::IsAwesome::Bitflipped;
# ABSTRACT: bitflipped's first Goodie
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "is_awesome_bitflipped";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome Bitflipped";
description "Prints nice message";
primary_example_queries "duckduckhack bitflipped";
secondary_example_queries "optional -- demonstrate any additional triggers";
category "special";
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/Bitflipped.pm";
attribution github => ["bitflipped", "Jon A"];


# Triggers
triggers start => "duckduckhack bitflipped";

# Handle statement
handle remainder => sub {

	# optional - regex guard
	#return unless qr/^\w+/;

	return if $_; # Guard against "no answer"

	return "bitflipped is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";
};

1;
