package DDG::Goodie::IsItChristmas;
# ABSTRACT: Answers the question of whether or not it is Christmas with a simple yes or no answer

use DDG::Goodie;
use DateTime;

zci answer_type => "is_it_christmas";
zci is_cached   => 1;

name "IsItChristmas";
description "Answers the question of whether or not it is Christmas with a simple yes or no";
primary_example_queries "is it christmas";
category "q/a";
topics "everyday";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsItChristmas.pm";
attribution github  => ["stevenmg", "Steve Glick"],
            web     => ['http://www.steveglick.net/', 'Steve Glick'],
            twitter => "stevenmglick";

# Triggers
triggers any => "is it christmas", "is it xmas";

# Handle statement
handle remainder => sub {
    my ($y, $m, $d) = Date::Calc::Today();

    if ($m == 12 && $d == 25) {
        return "Yes";
    } else {
        return "No";
    }
};

1;
