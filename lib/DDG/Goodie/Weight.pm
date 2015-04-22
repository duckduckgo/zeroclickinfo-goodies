package DDG::Goodie::Weight;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

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
        return "Weight of a ".$_."kg mass on Earth is ".$_*9.80665."N. Note: Taking value of acceleration due to gravity on Earth as 9.80665m/s^2.";
    }


};

1;
