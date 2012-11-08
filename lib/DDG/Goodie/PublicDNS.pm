package DDG::Goodie::PublicDNS;

use DDG::Goodie;

primary_example_queries 'public dns';
description 'list common public DNS servers and their IP addresses';
name 'Public DNS';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PublicDNS.pm';
category 'cheat_sheets';
topics 'sysadmin';

attribution github => ['https://github.com/warthurton', 'warthurton'];

triggers end => "public dns", "dns servers";

zci is_cached => 1;
zci answer_type => "public_dns";

handle sub {
	scalar share('publicdns.txt')->slurp,
	html => scalar share('publicdns.html')->slurp;
};

1;
