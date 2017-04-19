package DDG::Goodie::ReverseDNS;

use strict;

use DDG::Goodie;
use Socket;

triggers any => 'dns', 'lookup', 'ip', 'nslookup', 'dig', 'resolve', 'ptr';
zci is_cached => 0;
zci answer_type => 'reverse_dns';

description 'Returns the PTR resource record of a given IP address';
attribution github => ['https://github.com/koosha--', 'koosha--'],
			twitter => '_koosha_';
category 'computing_tools';

handle remainder => sub {
    return unless my $ip = _is_ip($_);
    my $addr = gethostbyaddr(inet_aton($ip), AF_INET);
    return "Reverse DNS lookup for IP $ip is $addr" if defined $addr;
    return;
};

sub _is_ip {
    my $ip = shift;
    my @parts = $ip =~ m/\s*(\d+)\.(\d+)\.(\d+)\.(\d+)\s*/;
    if (@parts == 4
        && $parts[0] != 127 # Prevent local lookups on DDG for security reasons 
        && $parts[0] <= 255 
        && $parts[1] <= 255 
        && $parts[2] <= 255 
        && $parts[3] <= 255) {
        return join('.', @parts);
    }
    return 0;
}

1;
