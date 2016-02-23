package DDG::Goodie::IsAwesome::PandiyanCool;
# ABSTRACT: PandiyanCool First attempt

use DDG::Goodie;
use strict;

zci answer_type => "is_awesome_pandiyan_cool";
zci is_cached   => 1;

triggers start => "duckduckhack pandiyancool";

handle remainder => sub {
    return if $_;
    return "PandiyanCool is techie saint who always interested to learn new things!";
};

1;
