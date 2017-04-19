package DDG::Goodie::WebsiteStatusCheck;
# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'website_status_check';

zci is_cached => 1;

triggers any => 'website status';

# Handle statement
handle remainder => sub {

    return '',
        structured_answer => {
            id => "website_status_check",
            data => {
                title    => 'Website Status Check',
                subtitle => 'Enter website url to check if it is up'
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.website_status_check.content'
                }
            }
        };
};

1;
