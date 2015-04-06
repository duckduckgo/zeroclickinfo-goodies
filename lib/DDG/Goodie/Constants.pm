package DDG::Goodie::Constants;
# ABSTRACT: Various Math and Physics constants.
use DDG::Goodie;
use YAML::XS qw( Load );

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
         
# Constants from the share.
my $constants = Load(scalar share("constants.yml")->slurp);

# Triggers
triggers any => %$constants;

# Handle statement
handle remainder => sub {
    return unless my $constant = $constants->{1729};
    if ($constant) {
        return $constant, structured_answer => {
            input     => [],
            operation => 'constants',
            result    => $constant
        };
    }
};

1;
