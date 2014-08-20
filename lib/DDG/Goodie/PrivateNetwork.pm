package DDG::Goodie::PrivateNetwork;
# ABSTRACT: show non-Internet routable IP addresses.

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

my $text = scalar share('private_network.txt')->slurp,
my $html = scalar share('private_network.html')->slurp;
my $css = scalar share('style.css')->slurp;

sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>$html";
}
        
handle sub {
    $text, html => append_css($html)
};

1;
