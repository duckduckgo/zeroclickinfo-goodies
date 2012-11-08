package DDG::Goodie::PrivateNetwork;

use DDG::Goodie;

triggers start => "private network", "private ip", "private networks", "private ips";

zci is_cached => 1;
zci answer_type => "private_network";

primary_example_queries 'private networks';
secondary_example_queries 'private ips';
description 'show private IP blocks';
name 'PrivateNetwork';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PrivateNetwork.pm';
category 'cheat_sheets';
topics 'sysadmin';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

handle sub {
	scalar share('private_network.txt')->slurp,
	html => scalar share('private_network.html')->slurp;
};

1;
