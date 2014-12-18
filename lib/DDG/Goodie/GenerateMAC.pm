package DDG::Goodie::GenerateMAC;
# ABSTRACT: generates a random network MAC address

use DDG::Goodie;

triggers startend => "generate mac addr",
                     "generate mac address",
                     "random mac addr",
                     "random mac address",
                     "mac address generator",
                     "mac address random";

zci answer_type => "MAC Address";
zci is_cached => 0;

primary_example_queries 'please generate mac address';
description 'generates a MAC address';
name "GenerateMAC";

attribution github => ['https://github.com/UnGround',  'Charlie Belmer'],
            web    => ['http://www.charliebelmer.com', 'Charlie Belmer'];

handle remainder => sub {
    # Ensure rand is seeded for each process
    srand();

    my $address = join(':', map { sprintf '%0.2X', rand(255) } (1 .. 6));

    return "Here's a random MAC address: $address",
      structured_answer => {
        input     => [],
        operation => 'random MAC address',
        result    => $address
      };
};

1;
