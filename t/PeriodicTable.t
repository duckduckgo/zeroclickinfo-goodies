#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "periodic_table";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::PeriodicTable )],
    # Tests for atomic mass
    "atomic mass of nitrogen" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "14.007",
            "Diatomic nonmetal",
            "1",
            "",
            "green"
        )
    ),
    # Test weight instead of mass
    "atomic weight of nitrogen" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "14.007",
            "Diatomic nonmetal",
            "1",
            "",
            "green"
        )
    ),
    #Test for quieres with additional fluff
    "what is the atomic weight for the nitrogen element" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "14.007",
            "Diatomic nonmetal",
            "1",
            "",
            "green"
        )
    ),    
    # Test nonsensical atomic weight.
    "atomic weight for nitrogen and oxygen" => undef,  
    "atomic weight of unobtainium" => undef,  
    "atomic weight" => undef,    
    "atomic mass" => undef,
    
    # Atomic number tests
    "atomic number of nitrogen" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "14.007",
            "Diatomic nonmetal",
            "",
            "1",
            "green"
        )
    ),
    "proton number of nitrogen" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "14.007",
            "Diatomic nonmetal",
            "",
            "1",
            "green"
        )
    ),    
    #Test for quieres with additional fluff
    "what is the proton number for the nitrogen element" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "14.007",
            "Diatomic nonmetal",
            "",
            "1",
            "green"
        )
    ),     
    # Test nonsensical atomic numbers.
    "atomic number for nitrogen and oxygen" => undef,  
    "atomic number of unobtainium" => undef,         
    "atomic number" => undef,
    
    # Test for chemical sysmbols
    "chemical symbol for nitrogen" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "14.007",
            "Diatomic nonmetal",
            "",
            "",
            "green"
        )
    ),  
    # Test for quieres with additional fluff
    "what is the chemical symbol for the nitrogen element" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "14.007",
            "Diatomic nonmetal",
            "",
            "",
            "green"
        )
    ),  
    "chemical symbol for nitrogen and oxygen" => undef,  
    "chemical symbol of unobtainium" => undef,        
    "chemical symbol" => undef,
    
    # Test for lookup of chemical names
    "chemical name for Au" => test_zci(
        "Gold (Au), atomic number 79, atomic mass 196.97 u",
        make_structured_answer(
            "Au",
            "Gold",
            "79",
            "196.97",
            "Transition metal",
            "",
            "",
            "red"
        )
    ),  
    # Test for quieres with additional fluff
    "what is the chemical name for Ag" => test_zci(
        "Silver (Ag), atomic number 47, atomic mass 107.87 u",
        make_structured_answer(
            "Ag",
            "Silver",
            "47",
            "107.87",
            "Transition metal",
            "",
            "",
            "red"
        )
    ),  
    "chemical name for nitrogen and oxygen" => undef,  
    "chemical name of unobtainium" => undef,        
    "chemical name" => undef,
    
    # Test the color for each of the element subgroups
    # Diatomic nonmetal
    "oxygen" => test_zci(
        "Oxygen (O), atomic number 8, atomic mass 15.999 u",
        make_structured_answer(
            "O",
            "Oxygen",
            "8",
            "15.999",
            "Diatomic nonmetal",
            "",
            "",
            "green"
        )
    ),
    # Alkali metal
    "lithium" => test_zci(
        "Lithium (Li), atomic number 3, atomic mass 6.94 u",
        make_structured_answer(
            "Li",
            "Lithium",
            "3",
            "6.94",
            "Alkali metal",
            "",
            "",
            "gold"
        )
    ),
    # Alkaline earth metal
    "beryllium" => test_zci(
        "Beryllium (Be), atomic number 4, atomic mass 9.0122 u",
        make_structured_answer(
            "Be",
            "Beryllium",
            "4",
            "9.0122",
            "Alkaline earth metal",
            "",
            "",
            "gold"
        )
    ),
    # Lanthanide
    "lanthanum" => test_zci(
        "Lanthanum (La), atomic number 57, atomic mass 138.91 u",
        make_structured_answer(
            "La",
            "Lanthanum",
            "57",
            "138.91",
            "Lanthanide",
            "",
            "",
            "red"
        )
    ),
    # Actinide
    "actinium" => test_zci(
        "Actinium (Ac), atomic number 89, atomic mass [227.03] u",
        make_structured_answer(
            "Ac",
            "Actinium",
            "89",
            "[227.03]",
            "Actinide",
            "",
            "",
            "red"
        )
    ), 
    # Transition metal
    "scandium" => test_zci(
        "Scandium (Sc), atomic number 21, atomic mass 44.956 u",
        make_structured_answer(
            "Sc",
            "Scandium",
            "21",
            "44.956",
            "Transition metal",
            "",
            "",
            "red"
        )
    ),
    # Post-transition metal
    "aluminium" => test_zci(
        "Aluminium (Al), atomic number 13, atomic mass 26.982 u",
        make_structured_answer(
            "Al",
            "Aluminium",
            "13",
            "26.982",
            "Post-transition metal",
            "",
            "",
            "green"
        )
    ),
    # Metalloid
    "boron" => test_zci(
        "Boron (B), atomic number 5, atomic mass 10.81 u",
        make_structured_answer(
            "B",
            "Boron",
            "5",
            "10.81",
            "Metalloid",
            "",
            "",
            "green"
        )
    ),
    # Polyatomic nonmetal
    "carbon" => test_zci(
        "Carbon (C), atomic number 6, atomic mass 12.011 u",
        make_structured_answer(
            "C",
            "Carbon",
            "6",
            "12.011",
            "Polyatomic nonmetal",
            "",
            "",
            "green"
        )
    ),
    # Noble gas
    "helium" => test_zci(
        "Helium (He), atomic number 2, atomic mass 4.0026 u",
        make_structured_answer(
            "He",
            "Helium",
            "2",
            "4.0026",
            "Noble gas",
            "",
            "",
            "blue-light"
        )
    ),    
    # Unknown
    "meitnerium" => test_zci(
        "Meitnerium (Mt), atomic number 109, atomic mass [276.15] u",
        make_structured_answer(
            "Mt",
            "Meitnerium",
            "109",
            "[276.15]",
            "Unknown",
            "",
            "",
            "red"
        )
    ),  
    
    # Tests for elements with double entries.
    "mercury" => test_zci(
        "Mercury (Hg), atomic number 80, atomic mass 200.59 u",
        make_structured_answer(
            "Hg",
            "Mercury",
            "80",
            "200.59",
            "Transition metal",
            "",
            "",
            "red"
        )
    ), 
    "hydrargyrum" => test_zci(
        "Hydrargyrum (Hg), atomic number 80, atomic mass 200.59 u",
        make_structured_answer(
            "Hg",
            "Hydrargyrum",
            "80",
            "200.59",
            "Transition metal",
            "",
            "",
            "red"
        )
    ), 
    
    # Tests for symbol length
    "oxygen" => test_zci(
        "Oxygen (O), atomic number 8, atomic mass 15.999 u",
        make_structured_answer(
            "O",
            "Oxygen",
            "8",
            "15.999",
            "Diatomic nonmetal",
            "",
            "",
            "green"
        )
    ),
    "lithium" => test_zci(
        "Lithium (Li), atomic number 3, atomic mass 6.94 u",
        make_structured_answer(
            "Li",
            "Lithium",
            "3",
            "6.94",
            "Alkali metal",
            "",
            "",
            "gold"
        )
    ),
    "ununoctium" => test_zci(
        "Ununoctium (Uuo), atomic number 118, atomic mass [294] u",
        make_structured_answer(
            "Uuo",
            "Ununoctium",
            "118",
            "[294]",
            "Unknown",
            "",
            "",
            "red"
        )
    ),    
);

sub make_structured_answer {
    my ($badge, $element_name, $atomic_number, $atomic_mass, $element_type,$is_mass_query, $is_number_query, $color) = @_;

    my $badge_class = "";
    my $symbol_length = length($badge);
    if ($symbol_length == 1) { $badge_class = "tx--25" }
    elsif ($symbol_length == 3) { $badge_class = "tx--14" }

    return structured_answer => {
        data => {
            badge => $badge,
            title => $element_name,
            subtitle => 'Chemical Element',
            atomic_number => $atomic_number,
            atomic_mass => $atomic_mass,
            element_type => $element_type,
            is_mass_query => $is_mass_query,
            is_number_query => $is_number_query,
            url => "https://en.wikipedia.org/wiki/$element_name",
        },        
        meta => {
            sourceName => "Wikipedia",
            sourceUrl => "https://en.wikipedia.org/wiki/$element_name" 
        }, 
        templates => {
            group => "icon",
            elClass => {
                bgColor => "bg-clr--$color",
                iconBadge => "tx-clr-white $badge_class",
                iconTitle => "tx--19",
                tileSubtitle => "tx--14"
            },
            variants => {
                iconBadge => "medium"
            },
            options => {
                content => 'DDH.periodic_table.content',
                moreAt => 1
            }
        }
    };   
};

done_testing;
