package DDG::Goodie::AndazApnaApna;
# ABSTRACT: Generate a random quote from the Hindi cult movie Andaz Apna Apna

use DDG::Goodie;
use strict;

zci answer_type => "andaz_apna_apna";
zci is_cached   => 1;

name "AndazApnaApna";
description "Returns a random quote from the Hindi cult movie Andaz Apna Apna";
primary_example_queries "andazapnaapna", "andaz apna apna";
secondary_example_queries "optional -- demonstrate any additional triggers";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/AndazApnaApna.pm";
attribution github => ["kobybecker", "Koby Becker"];
category 'entertainment';
topics "trivia", "geek", "special_interest", "entertainment"
# Triggers
triggers any => "andazapnaapna", "andaz apna apna", "andaz apna apna quotes", "andaz apna", "andaz apna apna movie";

my @quotes_list = share('quotes.txt')->slurp;
my @list_size = scalar @quotes_list;

# Handle statement
handle remainder => sub {

    return unless $_; # Guard against "no answer"

    # Fetch a random quote from the quotes_list
    return $quotes_list[int(rand scalar @quotes_list)];
};

1;
