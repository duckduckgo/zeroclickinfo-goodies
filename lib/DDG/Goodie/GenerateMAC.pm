package DDG::Goodie::GenerateMAC;
# ABSTRACT: generates a random network MAC address

use strict;
use DDG::Goodie;

triggers startend => "generate mac addr",
                     "generate mac address",
                     "random mac addr",
                     "random mac address",
                     "mac address generator",
                     "mac address random";

zci answer_type => "MAC Address";
zci is_cached => 0;

sub build_infobox_element {
    my $query = shift;
    my @split = split ' ', $query;
    return {
        label => $query,
        url   => 'https://duckduckgo.com/?q=' . (join '+', @split) . '&ia=answer',
    };
}

my $infobox = [ { heading => "Related Queries", },
                build_infobox_element('mac address 14:D6:4D:DA:79:6A'),
                build_infobox_element('ethernet address 00/00-03.ff:ff:FF'),
              ];

handle remainder => sub {
    # Ensure rand is seeded for each process
    srand();

    my $address = join(':', map { sprintf '%0.2X', rand(255) } (1 .. 6));

    return "Here's a random MAC address: $address", structured_answer => {
        data => {
            title => $address,
            description => 'Random MAC Address',
            infoboxData => $infobox
        },
        templates => {
            group => 'text'
        }    
    };
};

1;
