package DDG::Goodie::IsetCharguia;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "iset_charguia";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsetCharguia";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsetCharguia.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";




# Triggers
triggers start => 'iset charguia';

# Handle statement
handle remainder => sub {
    return 'L’Institut Superieur des Etudes Technologiques de CHARGUIA est une universite tunisienne creer en 2000.
Elle compte quatre departements :
	AA : Administration des affaires	
	TI : Technologie de l Informatique ' ;
    return;
};
1;