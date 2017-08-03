package DDG::Goodie::LoanCalculator;
# ABSTRACT: Interactive loan / interest calculator

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'loan_calculator';

zci is_cached => 1;
triggers any => ('loan calculator', 'mortgage calculator');

handle query_lc => sub {
    my $query_lc = $_;

    return 'plain text response',
        structured_answer => {

            data => {
                title => 'Loan Calculator',
            },

            templates => {
                group => 'text',
                options => {
                    content => "DDH.loan_calculator.content" 
                }
            }
        };
};

1;
