package DDG::Goodie::Planets;
# ABSTRACT: Return various attributes of a planet

use DDG::Goodie;
use YAML::XS qw( Load );

zci answer_type => "planets";
zci is_cached   => 1;

triggers startend => 'size of', 'planet size', 'what size is', 'volume';

name "Planets";
primary_example_queries 'size of venus';
secondary_example_queries 'what is the size of venus', 'volume of venus';
description 'Lookup various attributes of planets';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Planets.pm";
category 'conversions';
topics 'special_interest';
attribution github => 'chrisjwilsoncom',
            twitter => 'chrisjwilsoncom';

my $planets = Load(scalar share('planets.yml')->slurp);

# Handle statement
handle remainder_lc => sub {

	return unless $_; 

    my $value = $planets->{$_};

    return unless $value;

    return $value,
      structured_answer => {
        input     => [$_],
        operation => 'planet attributes',
        result    => $value
      };
};

1;
