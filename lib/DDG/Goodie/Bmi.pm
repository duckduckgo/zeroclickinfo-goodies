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

    # validate query & check for inputs here

    return 'BMI', structured_answer => {
        id => 'bmi',
        name => 'Body Mass Index Calculatior',
        data => {
            title => "Body Mass Index Calculation"
        },
        meta => {
            # maybe send them to a related Wiki article?
            sourceName => "Wiki",
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