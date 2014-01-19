package DDG::Goodie::ReverseIP;
# ABSTRACT: Do a reverse lookup for a bare IP (v4 only, for now) address.

use DDG::Goodie;
use Net::IP;
use Net::DNS;

zci is_cached   => 0;              # Let the tried and true DNS caching handle this.
zci answer_type => "reverse_ip";

primary_example_queries '127.0.0.1';
description 'reverse lookup of a bare IP4 address';
name 'reverse_ip';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ReverseIP.pm';
category 'computing_tools';
topics 'sysadmin';
attribution web => ['https://www.duckduckgo.com', 'DuckDuckGo'];

my $ip4_octet = qr/([01]?\d\d?|2[0-4]\d|25[0-5])/;      # Each octet should look like a number between 0 and 255.
my $ip4_regex = qr/^(?:$ip4_octet\.){3}$ip4_octet$/;    # There should be 4 of them separated by 3 dots.

triggers query => $ip4_regex;

my $timeout     = 1;                                    # Max seconds to wait for an answer. Even 1 seems like too long.
my $record_type = 'PTR';                                # We're only interested in pointer records.

handle query => sub {
    my $ip_candidate = shift;

    my $ip = Net::IP->new($ip_candidate);
    return unless ($ip);                                # Each guard gets us out as quickly as possible when
                                                        # it seems unlikely we'll be able to get an answer.

    my $resolver = Net::DNS::Resolver->new(
        tcp_timeout => $timeout,
        udp_timeout => $timeout,
    );
    return unless ($resolver);

    my $query = $resolver->query($ip_candidate, $record_type);
    return unless ($query);

    my @ptrs = map { $_->rdatastr } grep { $_->type eq $record_type } ($query->answer);
    return unless (@ptrs);

    return join(', ', @ptrs) . ' (Reverse DNS for ' . $ip_candidate . ')';
};

1;
