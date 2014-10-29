package DDG::Goodie::IndependenceDay;
# ABSTRACT: Goodie answer for different countries' national independence days

use DDG::Goodie;
use JSON;

zci answer_type => "independence_day";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "independence day";
description "Gives the date of when a nation assumed independence";
primary_example_queries "what is the independence day of norway", "independence day, papua new guinea";
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

    # delete noise from query string
    s/(national|independence of|independence|day of|day|when|what|is|the|for|)//g;
    # delete the whitespace left from query noise (spaces between words)
    s/^\s*|\s*$//g;
    # only the name of the country should be left in the string
    return unless $json->{$_};

    return ucfirst($_)." assumed independence on " . $json->{$_}->{'date'} . ", " . $json->{$_}->{'year'};

};

1;
