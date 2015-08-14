package DDG::Goodie::Bmi;
# ABSTRACT: A bmi calculator
# 
use DDG::Goodie;

zci answer_type => "bmi";
zci is_cached   => 1;

name "Bmi";
description "Pops a bmi calculator";
primary_example_queries "bmi";
category "calculations";
topics "special_interest", "everyday";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Bmi.pm";
attribution github => ["jrenouard", "Julien Renouard"],
            twitter => "jurenouard";

triggers start => "bmi";
triggers any => "bmi calculator", "body mass index calculator";

# Handle statement
handle remainder => sub {

    return 'BMI', structured_answer => {
        id => 'bmi',
        name => 'Body Mass Index Calculatior',
        data => {
            title => "Body Mass Index Calculation",
            text => {
                imperial => "Imperial",
                metric => "Metric",
                height_placeholder => "Height in cm",
                weight_placeholder => "Weight",
                calculate => "Calculate",
                feet => "Feet",
                inches => "Inches",
                pounds => "Pounds",
                range => ["very severely underweight",
                "severely underweight",
                "underweight",
                "normal",
                "overweight",
                "moderately obese",
                "severely  obese",
                "very severely obese"],
                error => "Error, your bmi is not a number, have you filled in the fields?",
                your_bmi => "Your bmi is ",
                within => "<br/>This is within the <b>",
                str_range => "</b> range",
                source_line => "<br/><small> source Wikipedia  <a href=\"https://en.wikipedia.org/wiki/Body_mass_index\">https://en.wikipedia.org/wiki/Body_mass_index</a></small>"
            },
        },
        meta => {
            sourceName => "Wikipedia",
            sourceUrl  => "https://en.wikipedia.org/wiki/Body_mass_index"
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.bmi.content',
                moreAt => 0
            }
        }
    };
};

1;