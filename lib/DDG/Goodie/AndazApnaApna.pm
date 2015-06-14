package DDG::Goodie::AndazApnaApna;
# ABSTRACT: Generate a random quote from the Hindi cult movie Andaz Apna Apna
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "andaz_apna_apna";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "AndazApnaApna";
description "Returns a random quote from the Hindi cult movie Andaz Apna Apna";
primary_example_queries "andazapnaapna", "andaz apna apna";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/AndazApnaApna.pm";
attribution github => ["kobybecker", "Koby Becker"];
category 'entertainment';
source "imdb"
topics "trivia", "geek", "special_interest", "entertainment"
# Triggers
triggers any => "andazapnaapna", "andaz apna apna", "andaz apna apna quotes", "andaz apna", "andaz apna apna movie";

my @quotes_list = share('quotes.txt')->slurp;
my @list_size = scalar @quotes_list;

# Handle statement
handle remainder => sub {

    # optional - regex guard
    # return unless qr/^\w+/;

    return unless $_; # Guard against "no answer"

    # Fetch a random quote from the quotes_list
    return $quotes_list[int(rand scalar @quotes_list)];
};

1;
