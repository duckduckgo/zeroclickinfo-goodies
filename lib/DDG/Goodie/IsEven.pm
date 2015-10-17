package DDG::Goodie::IsEven;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "is_even";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "IsEven";
description "Check if a numnber is even";
primary_example_queries "is 200 even";
secondary_example_queries "is -111     even?";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "calculations";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "math";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsEven.pm";
attribution github => ["https://github.com/FeiHong-Ren", "FeiHong-Ren"];

# Triggers
triggers any => "is", "even";

# Handle statement
handle query_lc => sub {
    return unless /is[\s]*(-?([\d]+))[\s]*even/;
    my $input = $2;
    if ($input%2 == 0){
        return "Yes";
    }else {
        return "No";
    }
};

1;
