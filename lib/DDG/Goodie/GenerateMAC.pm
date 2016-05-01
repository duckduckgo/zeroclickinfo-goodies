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

handle remainder => sub {
    # Ensure rand is seeded for each process
    srand();

    my $address = join(':', map { sprintf '%0.2X', rand(255) } (1 .. 6));

    return "Here's a random MAC address: $address",
      structured_answer => {
        input     => [],
        operation => 'Random MAC address',
        result    => $address
      };
};

1;
