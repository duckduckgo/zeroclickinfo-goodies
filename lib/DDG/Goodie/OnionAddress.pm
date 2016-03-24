package DDG::Goodie::OnionAddress;
# ABSTRACT: Recognize a web onion service address

use strict;
use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "onion_address";

# regex to detect an onion service address
# this cover several cases, including addresses with ports and/or paths
# e.g. https://3g2upl4pq6kufc4m.onion:5000/?q=dont+track+us
my $onion_address_qr = qr/(\w+:\/\/)?([a-z0-9]{16})\.onion(:\d+)?(\/.*)?/;

# add an optional question mark in case it's at the end of a question sentence
# e.g. How do I access https://0123456789abcdef.onion?
triggers query_lc => qr/\b$onion_address_qr(\?)?\b/;

handle query_lc => sub {

    # we only accept queries for web onion services
    # we also assume that an onion service without protocol:// should be web
    return unless !$1 or ($1 eq 'https://' or $1 eq 'http://' and $2);

    my $plaintext = $2.'.onion';
    return $plaintext,
    structured_answer => {
    	data => {
    		title => $2.'.onion',
            subtitle => 'Onion/Hidden service',
    		description => 'You are trying to reach an onion/hidden service. To access '.$2.'.onion via web you will have to use the Tor Browser.'
    	},
    	meta => {
            sourceName => "Tor Project",
            sourceUrl => "https://www.torproject.org/projects/torbrowser.html.en#downloads"
        },
        templates => {
            group => 'text',
            options => {
                moreAt => 1
            }
        }
    };
};

1;
