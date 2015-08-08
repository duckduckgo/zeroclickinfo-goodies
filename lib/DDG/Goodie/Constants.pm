package DDG::Goodie::Constants;
# ABSTRACT: Various Math and Physics constants.
use DDG::Goodie;
use YAML::XS qw( LoadFile );

zci answer_type => "constants";
zci is_cached   => 1;

name "Constants";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
category "formulas";
topics "math";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Constants.pm";
attribution github => ["hemanth", "Hemanth.HM"],
            twitter => "gnumanth";
         
my $constants = LoadFile(share("constants.yml"));
my @triggers = keys %{$constants};

triggers startend => @triggers;

# Handle statement
handle query_lc => sub {
    return unless my $val = $constants->{$_}; #lookup hash using query as key

    return $val, structured_answer => {
        input     => [],
        operation => 'Constants',
        result    => $val
    };
};

1;
