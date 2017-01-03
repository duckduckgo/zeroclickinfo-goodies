package DDG::Goodie::InteractiveBmiCalculator;
# Calculate your body mass index

use DDG::Goodie;

zci answer_type => "interactive_bmi_calculator";
zci is_cached   => 1;

triggers startend => "bmi calculator", "body mass index", "calculate bmi", "bmi formula", "how to calculate bmi";

handle query_lc => sub {
    my $text = 'Body Mass Index Calculator';

    return $text,
    structured_answer => {
        id => 'interactive_bmi_calculator',
        name => 'BMI Calculator',
        data => {
            title => $text,
#             infoboxData => [{
#                 label => "Underweight",
#                 value => "< 18.5"
#             },
#             {
#                 label => "Normal Weight",
#                 value => "18.5 - 24.9"
#             },
#             {
#                 label => "Overweight",
#                 value => "25 - 29.9"
#             },
#             {
#                 label => "Obesity",
#                 value => "30 or greater"
#             }
#             ]
        },
        templates => {
            group => 'text',
            options => {
                content => 'DDH.interactive_bmi_calculator.content'
            }
        }
    };
};

1;
