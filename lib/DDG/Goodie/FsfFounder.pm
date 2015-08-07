package DDG::Goodie::FsfFounder;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "fsf_founder";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "FsfFounder";
description "answer to the query free software foundation founder";
primary_example_queries "fsf founder", "free software foundation founder";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
category "computing_info";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
topics "computing";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FsfFounder.pm";
attribution github => ["marwendoukh", "Marwen Doukh"],
            twitter => "marwen.doukh";

# Triggers
triggers start => 'fsf founder';
# Handle statement
handle remainder => sub {
    return 'The Free Software Foundation was created by Richard Matthew Stallman (RMS) on 4 October 1985' ;
    return;
};
1;
