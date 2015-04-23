package DDG::Goodie::Weight;
# ABSTRACT: Calculate the weight of provided mass (in kg).

use strict;
use DDG::Goodie;
use Scalar::Util qw(looks_like_number);

zci answer_type => "weight";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "Weight";
description "Calculate the weight of provided mass (in kg).";
primary_example_queries "Weight 5", "Weight 5.12", "5.1 weight";
category "physical_properties";
topics "math", "science";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Weight.pm";
attribution github => ["https://github.com/wongalvis", "wongalvis"];

# Triggers
triggers startend => "weight";

# Handle statement
handle remainder => sub {
    
    return unless $_;
    
    return unless looks_like_number ($_);

    # Return only if $_ is a number
    if (looks_like_number($_)){
    
        my $mass = $_;
    
        # Value of acceleration due to gravity on Earth in m/s^2.
        my $g = 9.80665;
        
        # Weight = Mass (in kg) * Acceleration due to gravity (in m/s^2)
        my $weight = $mass*$g;
    
        return "Weight of a ".$mass."kg mass on Earth is ".$weight."N.",
            structured_answer => {
                input     => [],
                operation => "Taking value of acceleration due to gravity on Earth as ".$g."m/s^2.",
                result    => "Weight of a ".$mass."kg mass on Earth is ".$weight."N.",
            };
            
    }


};

1;
