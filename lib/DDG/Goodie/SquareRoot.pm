package DDG::Goodie::SquareRoot;
# ABSTRACT: Calculates Square Root of a Number

use DDG::Goodie;
use Math::Complex;

triggers startend => "sqrt", "square root", "square root of";

zci is_cached => 1;
zci answer_type => "square_root";

primary_example_queries 'sqrt 4';
secondary_example_queries 'square root 4', 'square root of 8';
description 'get the square root of the given number';
name 'SquareRoot';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SquareRoot.pm';
category 'calculations';
topics 'math';
attribution github => ["https://github.com/ritwikraghav14", "ritwikraghav14"],
            twitter => "ritwikraghav14";

handle remainder => sub {
    
    #Remove leading/trailing text from input
    s/^[a-zA-Z\s]+//;
    s/\s+[a-zA-Z]+$//;
    
    #Get the number in a variable
    my $num = $_;
    
    #return if @num==0;
    
    #Initialize the root
    my $rut = sqrt($num);
    
    return "Square Root: $rut", html => "<div class='root--container'><b><span class='root--key'>Square Root:</span></b> <span class='root--value'>$rut</span></div>";
};

1;