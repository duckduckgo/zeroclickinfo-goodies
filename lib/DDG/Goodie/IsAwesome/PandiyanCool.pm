package DDG::Goodie::IsAwesome::PandiyanCool;
# ABSTRACT: PandiyanCool First attempt


use DDG::Goodie;

zci answer_type => "is_awesome_pandiyan_cool";
zci is_cached   => 1;

name "IsAwesome PandiyanCool";
description "To make the world to know about pandiyan cool";
primary_example_queries "duckduckhack pandiyancool";

category "special";

topics "special_interest", "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/IsAwesome/PandiyanCool.pm";
attribution github => ["https://github.com/PandiyanCool", "Pandiyan"],
            twitter => "pandiyan_rsp";

triggers start => "duckduckhack pandiyancool";


handle remainder => sub {
    return if $_;
    return "PandiyanCool is techie saint who always interested to learn new things!";
};

1;
