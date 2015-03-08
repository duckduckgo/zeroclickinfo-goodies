package DDG::Goodie::MeltingBoilingPoints;

# ABSTRACT: Melting and Boiling points for various elements

use DDG::Goodie;
use YAML::XS qw(Load);
use List::Util qw(first);

zci answer_type => 'melting_boiling_points';
zci is_cached   => 1;

name 'Melting/boiling points';
description 'Melting and Boiling points for various elements';
primary_example_queries 'melting point of Nitrogen', 'boiling point of Oxygen';
category 'physical_properties';
topics 'science';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MeltingBoilingPoints.pm';
attribution github => [ 'javathunderman', 'Thomas Denizou' ];

my @points = @{ Load( scalar share('meltingboiling.yml')->slurp ) };

# Triggers
triggers start => 'melting point', 'boiling point', 'melting temperature', 'boiling temperature';

# Handle statement
handle query_lc => sub {

    my $query = $_;

    
    my $is_boiling_query = $query =~ /melting points|boiling points/;

  

    
    my $match = first { $query =~ /($_->[2])|($_->[3])/i } @points or return;
    my ( $melting_point, $boiling_point, $element_name, $element_symbol ) = @{$match};

    # Return the result if the element was found
    if ($is_boiling_query) {
        return "$element_name ($element_symbol), Boiling point $boiling_point Kelvin", structured_answer => {
            input     => ["$element_name ($element_symbol)"],
            operation => 'Boiling Point',
            result    => "$boiling_point Kelvin"
        };
    }
    else {
        return "$element_name ($element_symbol), Melting point $melting_point Kelvin", structured_answer => {
            input     => ["$element_name ($element_symbol)"],
            operation => 'Melting Point',
            result    => "$melting_point Kelvin"
        };
    }
};

1;
