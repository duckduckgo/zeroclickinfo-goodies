package DDG::Goodie::AreaCircle;
# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'area_circle';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
#triggers query_raw => qr/area\s+of\s+circle\s+radius\s+\d+/i;

triggers any => qw(area);

use constant PI => 22/7;

# Handle statement
handle remainder => sub {

    my $remainder = $_;

    return unless $remainder;

    my ($radius) = $remainder =~ /circle.*?radius\s+(\d+)/i;

    return unless $radius;

    my $answer = PI * $radius * $radius; 

    return $answer,
        structured_answer => {
            data => {
                title    => $answer,
                subtitle => "Area of Circle with radius $radius",
            },

            templates => {
                group => 'text',
            }
        };
};

1;
