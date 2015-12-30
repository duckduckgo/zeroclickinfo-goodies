#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
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
            "Atomic mass 14.007 u",
            "Nitrogen",
            "Atomic number 7",
            "green"
        )
    ),
    # Test weight instead of mass
    "atomic weight of nitrogen" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "Atomic mass 14.007 u",
            "Nitrogen",
            "Atomic number 7",
            "green"
        )
    ),
    #Test for quieres with additional fluff
    "what is the atomic weight for the nitrogen element" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "Atomic mass 14.007 u",
            "Nitrogen",
            "Atomic number 7",
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
            "Atomic number 7",
            "Nitrogen",
            "Atomic mass 14.007 u",
            "green"
        )
    ),
    "proton number of nitrogen" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "Atomic number 7",
            "Nitrogen",
            "Atomic mass 14.007 u",
            "green"
        )
    ),    
    #Test for quieres with additional fluff
    "what is the proton number for the nitrogen element" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "Atomic number 7",
            "Nitrogen",
            "Atomic mass 14.007 u",
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
            "Atomic number 7",
            "Nitrogen",
            "Atomic mass 14.007 u",
            "green"
        )
    ),  
    # Test for quieres with additional fluff
    "what is the chemical symbol for the nitrogen element" => test_zci(
        "Nitrogen (N), atomic number 7, atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "Atomic number 7",
            "Nitrogen",
            "Atomic mass 14.007 u",
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
            "Gold",
            "Atomic number 79",
            "Atomic mass 196.97 u",
            "red"
        )
    ),  
    # Test for quieres with additional fluff
    "what is the chemical name for Ag" => test_zci(
        "Silver (Ag), atomic number 47, atomic mass 107.87 u",
        make_structured_answer(
            "Ag",
            "Silver",
            "Silver",
            "Atomic number 47",
            "Atomic mass 107.87 u",
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
            "Atomic number 8",
            "Oxygen",
            "Atomic mass 15.999 u",
            "green"
        )
    ),
    # Alkali metal
    "lithium" => test_zci(
        "Lithium (Li), atomic number 3, atomic mass 6.94 u",
        make_structured_answer(
            "Li",
            "Lithium",
            "Atomic number 3",
            "Lithium",
            "Atomic mass 6.94 u",
            "gold"
        )
    ),
    # Alkaline earth metal
    "beryllium" => test_zci(
        "Beryllium (Be), atomic number 4, atomic mass 9.0122 u",
        make_structured_answer(
            "Be",
            "Beryllium",
            "Atomic number 4",
            "Beryllium",
            "Atomic mass 9.0122 u",
            "gold"
        )
    ),
    # Lanthanide
    "lanthanum" => test_zci(
        "Lanthanum (La), atomic number 57, atomic mass 138.91 u",
        make_structured_answer(
            "La",
            "Lanthanum",
            "Atomic number 57",
            "Lanthanum",
            "Atomic mass 138.91 u",
            "red"
        )
    ),
    # Actinide
    "actinium" => test_zci(
        "Actinium (Ac), atomic number 89, atomic mass [227.03] u",
        make_structured_answer(
            "Ac",
            "Actinium",
            "Atomic number 89",
            "Actinium",
            "Atomic mass [227.03] u",
            "red"
        )
    ), 
    # Transition metal
    "scandium" => test_zci(
        "Scandium (Sc), atomic number 21, atomic mass 44.956 u",
        make_structured_answer(
            "Sc",
            "Scandium",
            "Atomic number 21",
            "Scandium",
            "Atomic mass 44.956 u",
            "red"
        )
    ),
    # Post-transition metal
    "aluminium" => test_zci(
        "Aluminium (Al), atomic number 13, atomic mass 26.982 u",
        make_structured_answer(
            "Al",
            "Aluminium",
            "Atomic number 13",
            "Aluminium",
            "Atomic mass 26.982 u",
            "green"
        )
    ),
    # Metalloid
    "boron" => test_zci(
        "Boron (B), atomic number 5, atomic mass 10.81 u",
        make_structured_answer(
            "B",
            "Boron",
            "Atomic number 5",
            "Boron",
            "Atomic mass 10.81 u",
            "green"
        )
    ),
    # Polyatomic nonmetal
    "carbon" => test_zci(
        "Carbon (C), atomic number 6, atomic mass 12.011 u",
        make_structured_answer(
            "C",
            "Carbon",
            "Atomic number 6",
            "Carbon",
            "Atomic mass 12.011 u",
            "green"
        )
    ),
    # Noble gas
    "helium" => test_zci(
        "Helium (He), atomic number 2, atomic mass 4.0026 u",
        make_structured_answer(
            "He",
            "Helium",
            "Atomic number 2",
            "Helium",
            "Atomic mass 4.0026 u",
            "blue-light"
        )
    ),    
    # Unknown
    "meitnerium" => test_zci(
        "Meitnerium (Mt), atomic number 109, atomic mass [276.15] u",
        make_structured_answer(
            "Mt",
            "Meitnerium",
            "Atomic number 109",
            "Meitnerium",
            "Atomic mass [276.15] u",
            "red"
        )
    ),  
    
    # Tests for elements with double entries.
    "mercury" => test_zci(
        "Mercury (Hg), atomic number 80, atomic mass 200.59 u",
        make_structured_answer(
            "Hg",
            "Mercury",
            "Atomic number 80",
            "Mercury",
            "Atomic mass 200.59 u",
            "red"
        )
    ), 
    "hydrargyrum" => test_zci(
        "Hydrargyrum (Hg), atomic number 80, atomic mass 200.59 u",
        make_structured_answer(
            "Hg",
            "Hydrargyrum",
            "Atomic number 80",
            "Hydrargyrum",
            "Atomic mass 200.59 u",
            "red"
        )
    ), 
    
    # Tests for symbol length
    "oxygen" => test_zci(
        "Oxygen (O), atomic number 8, atomic mass 15.999 u",
        make_structured_answer(
            "O",
            "Oxygen",
            "Atomic number 8",
            "Oxygen",
            "Atomic mass 15.999 u",
            "green"
        )
    ),
    "lithium" => test_zci(
        "Lithium (Li), atomic number 3, atomic mass 6.94 u",
        make_structured_answer(
            "Li",
            "Lithium",
            "Atomic number 3",
            "Lithium",
            "Atomic mass 6.94 u",
            "gold"
        )
    ),
    "ununoctium" => test_zci(
        "Ununoctium (Uuo), atomic number 118, atomic mass [294] u",
        make_structured_answer(
            "Uuo",
            "Ununoctium",
            "Atomic number 118",
            "Ununoctium",
            "Atomic mass [294] u",
            "red"
        )
    ),    
);

sub make_structured_answer {
    my ($badge, $element_name, $title, $subtitle, $alt_subtitle, $color) = @_;

    my $badge_class = "";
    my $symbol_length = length($badge);
    if ($symbol_length == 1) { $badge_class = "tx--25" }
    elsif ($symbol_length == 3) { $badge_class = "tx--14" }

    return structured_answer => {
        id => "periodic_table",
        name => "Periodic Table",
        data => {
            badge => $badge,
            title => $title,
            subtitle => $subtitle,
            altSubtitle => $alt_subtitle,
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
                moreAt => 1
            }
        }
    };   
};

done_testing;
