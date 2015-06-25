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
        "Nitrogen (N), atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "14.007 u",
            "Nitrogen - atomic mass",
            "green"
        )
    ),
    # Test weight instead of mass
    "atomic weight of nitrogen" => test_zci(
        "Nitrogen (N), atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "14.007 u",
            "Nitrogen - atomic mass",
            "green"
        )
    ),
    #Test for quieres with additional fluff
    "what is the atomic weight for the nitrogen element" => test_zci(
        "Nitrogen (N), atomic mass 14.007 u",
        make_structured_answer(
            "N",
            "Nitrogen",
            "14.007 u",
            "Nitrogen - atomic mass",
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
        "Nitrogen (N), atomic number 7",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "Nitrogen - atomic number",
            "green"
        )
    ),
    "proton number of nitrogen" => test_zci(
        "Nitrogen (N), atomic number 7",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "Nitrogen - atomic number",
            "green"
        )
    ),    
    #Test for quieres with additional fluff
    "what is the proton number for the nitrogen element" => test_zci(
        "Nitrogen (N), atomic number 7",
        make_structured_answer(
            "N",
            "Nitrogen",
            "7",
            "Nitrogen - atomic number",
            "green"
        )
    ),     
    # Test nonsensical atomic numbers.
    "atomic number for nitrogen and oxygen" => undef,  
    "atomic number of unobtainium" => undef,         
    "atomic number" => undef,
    
    # Test for chemical sysmbols
    "chemical symbol for nitrogen" => test_zci(
        "N, chemical symbol for nitrogen",
        make_structured_answer(
            "N",
            "Nitrogen",
            "Nitrogen",
            "Chemical Element",
            "green"
        )
    ),  
    # Test for quieres with additional fluff
    "what is the chemical symbol for the nitrogen element" => test_zci(
        "N, chemical symbol for nitrogen",
        make_structured_answer(
            "N",
            "Nitrogen",
            "Nitrogen",
            "Chemical Element",
            "green"
        )
    ),  
    "chemical symbol for nitrogen and oxygen" => undef,  
    "chemical symbol of unobtainium" => undef,        
    "chemical symbol" => undef,
    
    # Test for lookup of chemical names
    "chemical name for Au" => test_zci(
        "Au, chemical symbol for gold",
        make_structured_answer(
            "Au",
            "Gold",
            "Gold",
            "Chemical Element",
            "red"
        )
    ),  
    # Test for quieres with additional fluff
    "what is the chemical name for Ag" => test_zci(
        "Ag, chemical symbol for silver",
        make_structured_answer(
            "Ag",
            "Silver",
            "Silver",
            "Chemical Element",
            "red"
        )
    ),  
    "chemical name for nitrogen and oxygen" => undef,  
    "chemical name of unobtainium" => undef,        
    "chemical name" => undef,
    
    # Test the color for each of the element subgroups
    # Diatomic nonmetal
    "oxygen" => test_zci(
        "O, chemical symbol for oxygen",
        make_structured_answer(
            "O",
            "Oxygen",
            "Oxygen",
            "Chemical Element",
            "green"
        )
    ),
    # Alkali metal
    "lithium" => test_zci(
        "Li, chemical symbol for lithium",
        make_structured_answer(
            "Li",
            "Lithium",
            "Lithium",
            "Chemical Element",
            "gold"
        )
    ),
    # Alkaline earth metal
    "beryllium" => test_zci(
        "Be, chemical symbol for beryllium",
        make_structured_answer(
            "Be",
            "Beryllium",
            "Beryllium",
            "Chemical Element",
            "gold"
        )
    ),
    # Lanthanide
    "lanthanum" => test_zci(
        "La, chemical symbol for lanthanum",
        make_structured_answer(
            "La",
            "Lanthanum",
            "Lanthanum",
            "Chemical Element",
            "red"
        )
    ),
    # Actinide
    "actinium" => test_zci(
        "Ac, chemical symbol for actinium",
        make_structured_answer(
            "Ac",
            "Actinium",
            "Actinium",
            "Chemical Element",
            "red"
        )
    ), 
    # Transition metal
    "scandium" => test_zci(
        "Sc, chemical symbol for scandium",
        make_structured_answer(
            "Sc",
            "Scandium",
            "Scandium",
            "Chemical Element",
            "red"
        )
    ),
    # Post-transition metal
    "aluminium" => test_zci(
        "Al, chemical symbol for aluminium",
        make_structured_answer(
            "Al",
            "Aluminium",
            "Aluminium",
            "Chemical Element",
            "green"
        )
    ),
    # Metalloid
    "boron" => test_zci(
        "B, chemical symbol for boron",
        make_structured_answer(
            "B",
            "Boron",
            "Boron",
            "Chemical Element",
            "green"
        )
    ),
    # Polyatomic nonmetal
    "carbon" => test_zci(
        "C, chemical symbol for carbon",
        make_structured_answer(
            "C",
            "Carbon",
            "Carbon",
            "Chemical Element",
            "green"
        )
    ),
    # Noble gas
    "helium" => test_zci(
        "He, chemical symbol for helium",
        make_structured_answer(
            "He",
            "Helium",
            "Helium",
            "Chemical Element",
            "blue-light"
        )
    ),    
    # Unknown
    "meitnerium" => test_zci(
        "Mt, chemical symbol for meitnerium",
        make_structured_answer(
            "Mt",
            "Meitnerium",
            "Meitnerium",
            "Chemical Element",
            "red"
        )
    ),  
    
    # Tests for elements with double entries.
    "mercury" => test_zci(
        "Hg, chemical symbol for mercury",
        make_structured_answer(
            "Hg",
            "Mercury",
            "Mercury",
            "Chemical Element",
            "red"
        )
    ), 
    "hydrargyrum" => test_zci(
        "Hg, chemical symbol for hydrargyrum",
        make_structured_answer(
            "Hg",
            "Hydrargyrum",
            "Hydrargyrum",
            "Chemical Element",
            "red"
        )
    ), 
    
    # Tests for symbol length
    "oxygen" => test_zci(
        "O, chemical symbol for oxygen",
        make_structured_answer(
            "O",
            "Oxygen",
            "Oxygen",
            "Chemical Element",
            "green"
        )
    ),
    "lithium" => test_zci(
        "Li, chemical symbol for lithium",
        make_structured_answer(
            "Li",
            "Lithium",
            "Lithium",
            "Chemical Element",
            "gold"
        )
    ),
    "ununoctium" => test_zci(
        "Uuo, chemical symbol for ununoctium",
        make_structured_answer(
            "Uuo",
            "Ununoctium",
            "Ununoctium",
            "Chemical Element",
            "red"
        )
    ),    
);

sub make_structured_answer {
    my ($badge, $element_name, $title, $subtitle, $color) = @_;

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
