package DDG::Goodie::PrivateNetwork;
# ABSTRACT: show non-Internet routable IP addresses.

use strict;
use DDG::Goodie;

triggers start => "private network", "private ip", "private networks", "private ips";

zci is_cached => 1;
zci answer_type => "private_network";

my $text = scalar share('private_network.txt')->slurp,
my $html = scalar share('private_network.html')->slurp;

handle sub {
    $text, html => $html
};

1;
