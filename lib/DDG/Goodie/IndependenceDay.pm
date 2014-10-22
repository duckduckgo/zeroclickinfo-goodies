package DDG::Goodie::IndependenceDay;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use JSON;

zci answer_type => "independence_day";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "independence day ";
description "Succinct explanation of what this instant answer does";
primary_example_queries "what is the independence day of norway", "independence day, peru";
secondary_example_queries "optional -- demonstrate any additional triggers";
category "dates";
topics "trivia";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IndependenceDay.pm";
attribution github => ["jarmokivekas", "Jarmo Kivekäs"],
            web => ["http://guttula.com", "Jarmo Kivekäs"];

# Triggers
triggers any => "independence day", "day of independence";

my $json = share('independence_days.json')->slurp;
$json = decode_json($json);

# Handle statement
handle query_clean => sub {

    # delete noise from query
    s/(independence|day of|day|when|what|is|the|for|)\s*//g;
    s/\s*$//;
    # return if there is nothing left
    return unless $json->{$_};


    return ucfirst($_)." assumed independence on " . $json->{$_}->{'date'} . ", " . $json->{$_}->{'year'};

};

1;
