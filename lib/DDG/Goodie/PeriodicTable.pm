package DDG::Goodie::PeriodicTable;

# ABSTRACT: Atomic masses and numbers for chemical elements

use DDG::Goodie;
use YAML::XS qw(Load);

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
triggers any => 'atomic mass', 'atomic weight', 'atomic number';

# Handle statement
handle query_lc => sub {

    my $query = $_;

    # Determine if this is a query for atomic mass or atomic number
    my $is_mass_query = $query =~ /atomic mass|atomic weight/;

    # Strip out irrelevant words in the query
    $query =~ s/(?:atomic (?:mass|weight|number)|of|the|element|elemental)//g;
    $query =~ s/^\s+|\s+$//g;
    return unless $query;

    # Look for a matching element in the table
    my $atomic_number;
    my $atomic_mass;
    my $element_name;
    my $element_symbol;
ELEMENT_SEARCH: foreach my $element (@elements) {

        # Some elements have multiple names or symbols
        if ( ref $element->[2] ) {
            for my $idx ( 0 .. $#{ $element->[2] } ) {
                if ( lc $element->[2]->[$idx] eq $query || lc $element->[3]->[$idx] eq $query ) {
                    $atomic_number  = $element->[0];
                    $atomic_mass    = $element->[1];
                    $element_name   = $element->[2]->[$idx];
                    $element_symbol = $element->[3]->[$idx];
                    last ELEMENT_SEARCH;
                }
            }
        }
        elsif ( lc $element->[2] eq $query || lc $element->[3] eq $query ) {
            ( $atomic_number, $atomic_mass, $element_name, $element_symbol ) = @{$element};
            last ELEMENT_SEARCH;
        }
    }
    return unless $atomic_number;

    # Return the result if the element was found
    if ($is_mass_query) {
        return "$element_name ($element_symbol), Atomic mass $atomic_mass u", structured_answer => {
            input     => ["$element_name ($element_symbol)"],
            operation => 'atomic mass',
            result    => "$atomic_mass u"
        };
    }
    else {
        return "$element_name ($element_symbol), Atomic number $atomic_number", structured_answer => {
            input     => ["$element_name ($element_symbol)"],
            operation => 'atomic number',
            result    => "$atomic_number"
        };
    }
};

1;
