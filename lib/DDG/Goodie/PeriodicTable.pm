package DDG::Goodie::PeriodicTable;

# ABSTRACT: Atomic masses and numbers for chemical elements

use DDG::Goodie;
use YAML::XS qw(Load);
use List::Util qw(first);

zci answer_type => 'periodic_table';
zci is_cached   => 1;

name 'Periodic Table';
description 'Atomic masses and numbers for chemical elements';
primary_example_queries 'atomic mass of Nitrogen', 'atomic number of Oxygen';
secondary_example_queries 'atomic weight of Na';
category 'physical_properties';
topics 'science';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PeriodicTable.pm';
attribution github => [ 'zblair', 'Zachary D Blair' ];

my @elements = @{ Load( scalar share('elements.yml')->slurp ) };

# Triggers
triggers any => 'atomic mass', 'atomic weight', 'atomic number', 'proton number';

# Handle statement
handle query_lc => sub {

    my $query = $_;

    # Determine if this is a query for atomic mass or atomic number
    my $is_mass_query = $query =~ /atomic mass|atomic weight/;

    # Strip out irrelevant words in the query
    $query =~ s/(?:atomic (?:mass|weight|number)|proton number|of|the|element|elemental)//g;
    $query =~ s/^\s+|\s+$//g;
    return unless $query;

    # Look for a matching element in the table
    my $match = first { lc $_->[2] eq $query || lc $_->[3] eq $query } @elements or return;
    my ( $atomic_number, $atomic_mass, $element_name, $element_symbol ) = @{$match};

    # Return the result if the element was found
    if ($is_mass_query) {
        return "$element_name ($element_symbol), Atomic mass $atomic_mass u", structured_answer => {
            input     => ["$element_name ($element_symbol)"],
            operation => 'Atomic Mass',
            result    => "$atomic_mass u"
        };
    }
    else {
        return "$element_name ($element_symbol), Atomic number $atomic_number", structured_answer => {
            input     => ["$element_name ($element_symbol)"],
            operation => 'Atomic Number',
            result    => $atomic_number
        };
    }
};

1;
