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

zci answer_type => "public_dns";

my $text = share('publicdns.txt')->slurp;
my $html = share('publicdns.html')->slurp;

handle sub {
    $text, html => $html;
};

1;
