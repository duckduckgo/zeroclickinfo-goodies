package DDG::Goodie::PackageTracking;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => 'package_tracking';
zci is_cached   => 1;

# Triggers
triggers any => 'triggerWord', 'trigger phrase';

# Handle statement
handle remainder => sub {
    # Query can be accessed in $_ 

    return $_;
};

1;
