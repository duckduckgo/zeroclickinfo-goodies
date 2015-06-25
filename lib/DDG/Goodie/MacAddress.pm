package DDG::Goodie::MacAddress;
# ABSTRACT: Vendor information lookup for MAC addresses

use strict;
use DDG::Goodie;

zci answer_type => "mac_address";
zci is_cached   => 1;

name "MacAddress";
description "Looks up the vendor associated with a MAC address by its OUI.";
primary_example_queries "mac address 14:D6:4D:DA:79:6A",
                        "mac address 2c-41-38-13-48-d2",
                        "mac address 3cb8.7a94.f542.e377";
secondary_example_queries "ethernet address 00/00-03.ff:ff:FF";
category "computing_info";
topics "sysadmin";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MacAddress.pm";
attribution web     => ["http://mogigoma.com/",         "Mak Kolybabi"],
            github  => ["https://github.com/mogigoma",  "Mogigoma"],
            twitter => ["https://twitter.com/mogigoma", "Mogigoma"];

triggers startend => "mac address", "ethernet address";

my %oui_db = map { chomp; my (@f) = split(/\\n/, $_, 2); ($f[0] => $f[1]); } share("oui_database.txt")->slurp;

sub fmt_mac {
    my $mac = shift;
    $mac = lc($mac);
    $mac =~ s/..\K(?=.)/:/g;
    $mac;
}

handle remainder => sub {
    return unless $_;
    return unless $_ =~ m|^[-.:/ 0-9a-f]+$|i;
    $_ =~ s/[^0-9a-fA-F]//g;
    return unless (length($_) == 12 || length($_) == 16);

    my ($oui) = uc(substr($_, 0, 6));
    my ($info) = $oui_db{$oui};
    return unless $info;
    my (@vendor) = split(/\\n/, $info, 2);

    my ($name, $addr) = map { html_enc($_); } @vendor;
    $addr = "No associated address" unless defined $addr;

    # If the info is all capitals, then try to add in some best guesses for
    # capitalization to make it more readable.
    #
    # Decide whether to do this replacement per-line, since there are often
    # errant unformatted lines amongst formatted ones.
    my (@lines) = split(/\\n/, $info);
    foreach my $line (@lines) {
      if ($line !~ m/[a-z]/) {
        $line =~ s/(\w+)/ucfirst(lc($1))/eg;
      }
    }

    my ($result) = join("", map { "<p class=\"macaddress\">$_</p>"; } @lines);
    $result =~ s/class="macaddress"/class="macaddress title"/;

    return "The OUI, " . fmt_mac($oui) . ", for this NIC is assigned to " . $name,
      structured_answer => {
        input     => [fmt_mac($_)],
        operation => "MAC Address",
        result    => $result
      };
};

1;
