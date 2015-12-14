package DDG::Goodie::PackageTracking;
# ABSTRACT:  Track a shipment from any courier

use DDG::Goodie;
use DDG::GoodiePackageTracking;
use strict;

zci answer_type => 'package_tracking';
zci is_cached   => 1;

triggers any => 'triggerWord', 'trigger phrase';

# Handle statement
handle remainder => sub {

    my $remainder = $_;

    return "plain text response",
        structured_answer => {
            id => 'package_tracking',
            name => 'Answer',

            data => {
              title => "My Instant Answer Title",
              subtitle => "My Subtitle",
            },

            templates => {
                group => "text",
            }
        };
};

1;
