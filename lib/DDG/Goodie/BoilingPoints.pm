package DDG::Goodie::BoilingPoints;
# ABSTRACT: Returns boiling points of common elements

use DDG::Goodie;
use LWP::Simple;

zci answer_type => "boiling_points";
zci is_cached   => 1;

name "BoilingPoints";
description "Returns boiling points of common elements";
primary_example_queries "boiling point of nitrogen";
category "facts";
topics "science", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/BoilingPoints.pm";
attribution github => ["https://github.com/ag8", "ag8"];

triggers start => "boiling point of", "boiling point";

handle remainder => sub {

    if (($_ eq "actinium") == 1) {return "3200 degrees Celcius";}
	elsif (($_ eq "aluminium") == 1) {return "2519 degrees Celcius";}
	elsif (($_ eq "americium") == 1) {return "2011 degrees Celcius";}
	elsif (($_ eq "antimony") == 1) {return "1587 degrees Celcius";}
	elsif (($_ eq "argon") == 1) {return "-185.8 degrees Celcius";}
	elsif (($_ eq "arsenic") == 1) {return "614 degrees Celcius";}
	elsif (($_ eq "astatine") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "barium") == 1) {return "1870 degrees Celcius";}
	elsif (($_ eq "berkelium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "beryllium") == 1) {return "2470 degrees Celcius";}
	elsif (($_ eq "bismuth") == 1) {return "1564 degrees Celcius";}
	elsif (($_ eq "bohrium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "boron") == 1) {return "4000 degrees Celcius";}
	elsif (($_ eq "bromine") == 1) {return "59 degrees Celcius";}
	elsif (($_ eq "cadmium") == 1) {return "767 degrees Celcius";}
	elsif (($_ eq "caesium") == 1) {return "671 degrees Celcius";}
	elsif (($_ eq "calcium") == 1) {return "1484 degrees Celcius";}
	elsif (($_ eq "californium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "carbon") == 1) {return "4027 degrees Celcius";}
	elsif (($_ eq "cerium") == 1) {return "3360 degrees Celcius";}
	elsif (($_ eq "chlorine") == 1) {return "-34.04 degrees Celcius";}
	elsif (($_ eq "chromium") == 1) {return "2671 degrees Celcius";}
	elsif (($_ eq "cobalt") == 1) {return "2927 degrees Celcius";}
	elsif (($_ eq "copernicium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "copper") == 1) {return "2927 degrees Celcius";}
	elsif (($_ eq "curium") == 1) {return "3110 degrees Celcius";}
	elsif (($_ eq "darmstadtium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "dubnium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "dysprosium") == 1) {return "2567 degrees Celcius";}
	elsif (($_ eq "einsteinium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "erbium") == 1) {return "2868 degrees Celcius";}
	elsif (($_ eq "europium") == 1) {return "1527 degrees Celcius";}
	elsif (($_ eq "fermium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "flerovium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "fluorine") == 1) {return "-118.12 degrees Celcius";}
	elsif (($_ eq "francium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "gadolinium") == 1) {return "3250 degrees Celcius";}
	elsif (($_ eq "gallium") == 1) {return "2204 degrees Celcius";}
	elsif (($_ eq "germanium") == 1) {return "2820 degrees Celcius";}
	elsif (($_ eq "gold") == 1) {return "2856 degrees Celcius";}
	elsif (($_ eq "hafnium") == 1) {return "4603 degrees Celcius";}
	elsif (($_ eq "hassium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "helium") == 1) {return "-268.93 degrees Celcius";}
	elsif (($_ eq "holmium") == 1) {return "2700 degrees Celcius";}
	elsif (($_ eq "hydrogen") == 1) {return "-252.87 degrees Celcius";}
	elsif (($_ eq "indium") == 1) {return "2072 degrees Celcius";}
	elsif (($_ eq "iodine") == 1) {return "184.3 degrees Celcius";}
	elsif (($_ eq "iridium") == 1) {return "4428 degrees Celcius";}
	elsif (($_ eq "iron") == 1) {return "2861 degrees Celcius";}
	elsif (($_ eq "krypton") == 1) {return "-153.22 degrees Celcius";}
	elsif (($_ eq "lanthanum") == 1) {return "2464 degrees Celcius";}
	elsif (($_ eq "lawrencium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "lead") == 1) {return "1749 degrees Celcius";}
	elsif (($_ eq "lithium") == 1) {return "1342 degrees Celcius";}
	elsif (($_ eq "livermorium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "lutetium") == 1) {return "3402 degrees Celcius";}
	elsif (($_ eq "magnesium") == 1) {return "1090 degrees Celcius";}
	elsif (($_ eq "manganese") == 1) {return "2061 degrees Celcius";}
	elsif (($_ eq "meitnerium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "mendelevium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "mercury") == 1) {return "356.73 degrees Celcius";}
	elsif (($_ eq "molybdenum") == 1) {return "4639 degrees Celcius";}
	elsif (($_ eq "neodymium") == 1) {return "3100 degrees Celcius";}
	elsif (($_ eq "neon") == 1) {return "-246.08 degrees Celcius";}
	elsif (($_ eq "neptunium") == 1) {return "4000 degrees Celcius";}
	elsif (($_ eq "nickel") == 1) {return "2913 degrees Celcius";}
	elsif (($_ eq "niobium") == 1) {return "4744 degrees Celcius";}
	elsif (($_ eq "nitrogen") == 1) {return "-195.79 degrees Celcius";}
	elsif (($_ eq "nobelium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "osmium") == 1) {return "5012 degrees Celcius";}
	elsif (($_ eq "oxygen") == 1) {return "-182.9 degrees Celcius";}
	elsif (($_ eq "palladium") == 1) {return "2963 degrees Celcius";}
	elsif (($_ eq "phosphorus") == 1) {return "280.5 degrees Celcius";}
	elsif (($_ eq "platinum") == 1) {return "3825 degrees Celcius";}
	elsif (($_ eq "plutonium") == 1) {return "3230 degrees Celcius";}
	elsif (($_ eq "polonium") == 1) {return "962 degrees Celcius";}
	elsif (($_ eq "potassium") == 1) {return "759 degrees Celcius";}
	elsif (($_ eq "praseodymium") == 1) {return "3290 degrees Celcius";}
	elsif (($_ eq "promethium") == 1) {return "3000 degrees Celcius";}
	elsif (($_ eq "protactinium") == 1) {return "4000 degrees Celcius";}
	elsif (($_ eq "radium") == 1) {return "1737 degrees Celcius";}
	elsif (($_ eq "radon") == 1) {return "-61.7 degrees Celcius";}
	elsif (($_ eq "rhenium") == 1) {return "5596 degrees Celcius";}
	elsif (($_ eq "rhodium") == 1) {return "3695 degrees Celcius";}
	elsif (($_ eq "roentgenium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "rubidium") == 1) {return "688 degrees Celcius";}
	elsif (($_ eq "ruthenium") == 1) {return "4150 degrees Celcius";}
	elsif (($_ eq "rutherfordium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "samarium") == 1) {return "1803 degrees Celcius";}
	elsif (($_ eq "scandium") == 1) {return "2830 degrees Celcius";}
	elsif (($_ eq "seaborgium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "selenium") == 1) {return "685 degrees Celcius";}
	elsif (($_ eq "silicon") == 1) {return "2900 degrees Celcius";}
	elsif (($_ eq "silver") == 1) {return "2162 degrees Celcius";}
	elsif (($_ eq "sodium") == 1) {return "883 degrees Celcius";}
	elsif (($_ eq "strontium") == 1) {return "1382 degrees Celcius";}
	elsif (($_ eq "sulfur") == 1) {return "444.72 degrees Celcius";}
	elsif (($_ eq "tantalum") == 1) {return "5458 degrees Celcius";}
	elsif (($_ eq "technetium") == 1) {return "4265 degrees Celcius";}
	elsif (($_ eq "tellurium") == 1) {return "988 degrees Celcius";}
	elsif (($_ eq "terbium") == 1) {return "3230 degrees Celcius";}
	elsif (($_ eq "thallium") == 1) {return "1473 degrees Celcius";}
	elsif (($_ eq "thorium") == 1) {return "4820 degrees Celcius";}
	elsif (($_ eq "thulium") == 1) {return "1950 degrees Celcius";}
	elsif (($_ eq "tin") == 1) {return "2602 degrees Celcius";}
	elsif (($_ eq "titanium") == 1) {return "3287 degrees Celcius";}
	elsif (($_ eq "tungsten") == 1) {return "5555 degrees Celcius";}
	elsif (($_ eq "ununoctium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "ununpentium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "ununseptium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "ununtrium") == 1) {return "N/A degrees Celcius";}
	elsif (($_ eq "uranium") == 1) {return "3927 degrees Celcius";}
	elsif (($_ eq "vanadium") == 1) {return "3407 degrees Celcius";}
	elsif (($_ eq "xenon") == 1) {return "-108 degrees Celcius";}
	elsif (($_ eq "ytterbium") == 1) {return "1196 degrees Celcius";}
	elsif (($_ eq "yttrium") == 1) {return "3345 degrees Celcius";}
	elsif (($_ eq "zinc") == 1) {return "907 degrees Celcius";}
	elsif (($_ eq "zirconium") == 1) {return "4409 degrees Celcius";}
    else {return;}#no answer
};

1;
