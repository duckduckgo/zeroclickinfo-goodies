package DDG::Goodie::OnionAddress;
# ABSTRACT: Provide quick access to HTTP onion services.

use strict;
use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "onion_address";

primary_example_queries 'https://3g2upl4pq6kufc4m.onion';
secondary_example_queries 'How do I access https://3g2upl4pq6kufc4m.onion:81/?q=dont+track+us?';
description 'Provide quick access to HTTP onion services';
name 'OnionAddress';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/OnionAddress.pm';
category 'reference';
topics 'special_interest', 'cryptography';
attribution email => 'ilv@torproject.org';

# regex to detect an onion address
# this cover several cases, including addresses with ports and/or paths
# e.g. https://3g2upl4pq6kufc4m.onion:5000/?q=dont+track+us
my $onion_address_qr = qr/\bhttps?:\/\/([a-z0-9]{16})\.onion[:\d+]?[\/.*]?\b/;

# add an optional question mark in case it's at the end of a question sentence
# e.g. How do I access https://0123456789abcdef.onion?
triggers query_lc => qr/$onion_address_qr[\?]?/;

handle query_lc => sub {

    return unless $1;
    return $1, html => "<div class='zci__caption'>Access $1.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://$1.tor2web.org'>Tor2web</a>.</div>";

};

1;
