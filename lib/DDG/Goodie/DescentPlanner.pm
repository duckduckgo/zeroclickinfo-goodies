package DDG::Goodie::DescentPlanner;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "descent_planner";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "DescentPlanner";
description "Calculates when to start a descent from one altitude to another.";
primary_example_queries "descend from 350 to 3000", "descend from 9000 to 23";
#secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
category "calculations";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
topics "special_interest";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DescentPlanner.pm";
attribution github => ["umvegas", "Matthew Vega"],
            twitter => "\@umvegas";

# Triggers
triggers start => "descend from";

# Handle statement
handle remainder => sub {

    # optional - regex guard
    return unless qr/^\w+/;

    return unless $_; # Guard against "no answer"

    my @ml = /^\s*(?:FL)?(\d{3})\s*to\s*(?:FL)?(\d{1,3})/i;

    return unless @ml;

    my $top = $ml[0];
    my $bottom = $ml[1];
    my $diff = $top - $bottom;
    my $ruleOf3 = int($diff / 3 + 0.5);
    return "To descend from " . $_ . ", begin about " . $ruleOf3 . " nautical miles from your target";
};

1;
