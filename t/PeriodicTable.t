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
    'atomic mass of nitrogen' => test_zci(
        'Nitrogen (N), atomic mass 14.007 u',
        make_structured_answer(
            "N",
            "14.007 u",
            "Nitrogen - atomic mass",
            "green"
        )
    ),
    # Test weight instead of mass
    'atomic weight of nitrogen' => test_zci(
        'Nitrogen (N), atomic mass 14.007 u',
        make_structured_answer(
            "N",
            "14.007 u",
            "Nitrogen - atomic mass",
            "green"
        )
    ),
    #Test for quieres with additional fluff
    'what is the atomic weight for the nitrogen element' => test_zci(
        'Nitrogen (N), atomic mass 14.007 u',
        make_structured_answer(
            "N",
            "14.007 u",
            "Nitrogen - atomic mass",
            "green"
        )
    ),    
    # Test nonsensical atomic weight.
    'atomic weight for nitrogen and oxygen' => undef,  
    'atomic weight of unobtainium' => undef,  
    'atomic weight' => undef,    
    'atomic mass' => undef,
    
    # Atomic number tests
    'atomic number of nitrogen' => test_zci(
        'Nitrogen (N), atomic number 7',
        make_structured_answer(
            "N",
            "7",
            "Nitrogen - atomic number",
            "green"
        )
    ),
    'proton number of nitrogen' => test_zci(
        'Nitrogen (N), atomic number 7',
        make_structured_answer(
            "N",
            "7",
            "Nitrogen - atomic number",
            "green"
        )
    ),    
    #Test for quieres with additional fluff
    'what is the proton number for the nitrogen element' => test_zci(
        'Nitrogen (N), atomic number 7',
        make_structured_answer(
            "N",
            "7",
            "Nitrogen - atomic number",
            "green"
        )
    ),     
    # Test nonsensical atomic numbers.
    'atomic number for nitrogen and oxygen' => undef,  
    'atomic number of unobtainium' => undef,         
    'atomic number' => undef,
    
    # Test for chemical sysmbols
    'chemical symbol for nitrogen' => test_zci(
        'N, chemical symbol for nitrogen',
        make_structured_answer(
            "N",
            "Nitrogen",
            "Atomic number 7. Atomic mass 14.007 u.",
            "green"
        )
    ),  
    # Test for quieres with additional fluff
    'what is the chemical symbol for the nitrogen element' => test_zci(
        'N, chemical symbol for nitrogen',
        make_structured_answer(
            "N",
            "Nitrogen",
            "Atomic number 7. Atomic mass 14.007 u.",
            "green"
        )
    ),  
    'chemical symbol for nitrogen and oxygen' => undef,  
    'chemical symbol of unobtainium' => undef,        
    'chemical symbol' => undef,
    
    # Test for lookup of chemical names
    'chemical name for Au' => test_zci(
        'Au, chemical symbol for gold',
        make_structured_answer(
            "Au",
            "Gold",
            "Atomic number 79. Atomic mass 196.97 u.",
            "red"
        )
    ),  
    # Test for quieres with additional fluff
    'what is the chemical name for Ag' => test_zci(
        'Ag, chemical symbol for silver',
        make_structured_answer(
            "Ag",
            "Silver",
            "Atomic number 47. Atomic mass 107.87 u.",
            "red"
        )
    ),  
    'chemical name for nitrogen and oxygen' => undef,  
    'chemical name of unobtainium' => undef,        
    'chemical name' => undef,
    
    # Test the color for each of the element subgroups
    # Diatomic nonmetal
    'oxygen' => test_zci(
        'O, chemical symbol for oxygen',
        make_structured_answer(
            "O",
            "Oxygen",
            "Atomic number 8. Atomic mass 15.999 u.",
            "green"
        )
    ),
    # Alkali metal
    'lithium' => test_zci(
        'Li, chemical symbol for lithium',
        make_structured_answer(
            "Li",
            "Lithium",
            "Atomic number 3. Atomic mass 6.94 u.",
            "gold"
        )
    ),
    # Alkaline earth metal
    'beryllium' => test_zci(
        'Be, chemical symbol for beryllium',
        make_structured_answer(
            "Be",
            "Beryllium",
            "Atomic number 4. Atomic mass 9.0122 u.",
            "gold"
        )
    ),
    # Lanthanide
    'lanthanum' => test_zci(
        'La, chemical symbol for lanthanum',
        make_structured_answer(
            "La",
            "Lanthanum",
            "Atomic number 57. Atomic mass 138.91 u.",
            "red"
        )
    ),
    # Actinide
    'actinium' => test_zci(
        'Ac, chemical symbol for actinium',
        make_structured_answer(
            "Ac",
            "Actinium",
            "Atomic number 89. Atomic mass [227.03] u.",
            "red"
        )
    ), 
    # Transition metal
    'scandium' => test_zci(
        'Sc, chemical symbol for scandium',
        make_structured_answer(
            "Sc",
            "Scandium",
            "Atomic number 21. Atomic mass 44.956 u.",
            "red"
        )
    ),
    # Post-transition metal
    'aluminium' => test_zci(
        'Al, chemical symbol for aluminium',
        make_structured_answer(
            "Al",
            "Aluminium",
            "Atomic number 13. Atomic mass 26.982 u.",
            "green"
        )
    ),
    # Metalloid
    'boron' => test_zci(
        'B, chemical symbol for boron',
        make_structured_answer(
            "B",
            "Boron",
            "Atomic number 5. Atomic mass 10.81 u.",
            "green"
        )
    ),
    # Polyatomic nonmetal
    'carbon' => test_zci(
        'C, chemical symbol for carbon',
        make_structured_answer(
            "C",
            "Carbon",
            "Atomic number 6. Atomic mass 12.011 u.",
            "green"
        )
    ),
    # Noble gas
    'helium' => test_zci(
        'He, chemical symbol for helium',
        make_structured_answer(
            "He",
            "Helium",
            "Atomic number 2. Atomic mass 4.0026 u.",
            "blue-light"
        )
    ),    
    # Unknown
    'meitnerium' => test_zci(
        'Mt, chemical symbol for meitnerium',
        make_structured_answer(
            "Mt",
            "Meitnerium",
            "Atomic number 109. Atomic mass [276.15] u.",
            "red"
        )
    ),  
    
    # Tests for elements with double entries.
    'mercury' => test_zci(
        'Hg, chemical symbol for mercury',
        make_structured_answer(
            "Hg",
            "Mercury",
            "Atomic number 80. Atomic mass 200.59 u.",
            "red"
        )
    ), 
    'hydrargyrum' => test_zci(
        'Hg, chemical symbol for hydrargyrum',
        make_structured_answer(
            "Hg",
            "Hydrargyrum",
            "Atomic number 80. Atomic mass 200.59 u.",
            "red"
        )
    ), 
);

sub make_structured_answer {
    my ($badge ,$title, $subtitle, $color) = @_;

    return structured_answer => {
        id => "periodic_table",
        name => "Periodic Table",
        data => {
            badge => $badge,
            title => $title,
            subtitle => $subtitle,
            description => ""
        },
        templates => {
            group => "icon",
            elClass => {
                bgColor => "bg-clr--$color",
                iconBadge => "tx-clr-white"
            },
            variants => {
                iconBadge => "medium"
            },
            options => {
                moreAt => 0
            }
        }
    };   
};

done_testing;
