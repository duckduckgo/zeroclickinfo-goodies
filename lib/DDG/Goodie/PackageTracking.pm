package DDG::Goodie::PackageTracking;
# ABSTRACT: track a package.

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
