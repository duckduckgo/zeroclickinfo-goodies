package DDG::Goodie::Teredo;
# ABSTRACT: Provides the Teredo server IPv4 address,
# NAT IPv4 address, and port number encoded in a given
# Teredo tunnel IPv6 address.

use DDG::Goodie;
use Net::IP;
use Math::BaseConvert;

triggers start => 'teredo';

primary_example_queries 'teredo 2001:0000:4136:e378:8000:63bf:3fff:fdd2';
description 'Teredo address analyzer';
name 'Teredo extractor';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Teredo.pm';
topics 'sysadmin';
category 'transformations';
attribution github => ['seanheaton','Sean Heaton'],
            twitter => ['seanograph','Sean Heaton'],
            email => ['seanoftime@gmail.com','seanoftime@gmail.com'];

zci answer_type => 'teredo';
zci is_cached   => 1;

handle remainder => sub {
    my @output = ();

    # Create an IPv6 address from the query value
    my $ip = new Net::IP ($_,6) if $_;

    # Verify the query value is a valid Teredo IPv6 address
    if ((defined $ip) && ($ip->version() == 6) && (substr($ip->ip(),0,9) eq "2001:0000")) {
	my $binip = $ip->binip();

	# bits 32 to 64 designate IPv4 address of the Teredo server used
	push @output, (new Net::IP (Net::IP::ip_bintoip((substr $binip, 32, 32),4)));

	# negation of bits 80 to 96, converted to decimal, designate NAT port number
	push @output, (65535 - cnv((substr $binip, 80, 16),2,10));

	# negation of bits 96 to 128 designate IPv4 address of NAT device
	push @output, (new Net::IP (Net::IP::ip_bintoip(~(substr $binip, 96, 32),4)));
	return answer => to_text(@output), html => to_html(@output);
    }
    return;

    # Params: server, port, client
    sub to_text {
	return "Teredo Server IPv4: " . $_[0]->ip() . "\nNAT Public IPv4: " . $_[2]->ip()
		. "\nClient Port: " . $_[1];
    }

    # Params: server, port, client
    sub to_html {
	return "<div><span class=\"teredo__label text--secondary\">Teredo Server IPv4: </span><span class=\"text--primary\">" . $_[0]->ip()
	. "</span></div><div><span class=\"teredo__label text--secondary\">NAT Public IPv4: </span><span class=\"text--primary\">" . $_[2]->ip()
	. "</span></div><div><span class=\"teredo__label text--secondary\">Client Port: </span><span class=\"text--primary\">" . $_[1] . "</span></div>";
    }
};

1;
