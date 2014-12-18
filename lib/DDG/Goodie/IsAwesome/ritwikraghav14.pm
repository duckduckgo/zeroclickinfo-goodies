package DDG::Goodie::IsAwesome::ritwikraghav14;
# ABSTRACT: ritwikraghav14's first Goodie
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "is_awesome_ritwikraghav14";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsAwesome ritwikraghav14";
description "My first Goodie, it let's the world know that ritwikraghav14 is awesome";
primary_example_queries "duckduckhack ritwikraghav14";
# secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
category "special";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/ritwikraghav14.pm";
attribution github => ["https://github.com/ritwikraghav14", "ritwikraghav14"],
            twitter => "ritwikraghav14";

# Triggers
triggers start => "duckduckhack ritwikraghav14";

# Handle statement
handle remainder => sub {

	# optional - regex guard
	# return unless qr/^\w+/;
    return if $_;
    return "ritwikraghav14 is awesome and has successfully completed the DuckDuckHack Goodie tutorial!";

	#return unless $_; # Guard against "no answer"

	#return $_;
};

1;
