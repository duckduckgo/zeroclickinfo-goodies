package DDG::Goodie::MacAddress;
# ABSTRACT: Vendor information lookup for MAC addresses

use strict;
use DDG::Goodie;

zci answer_type => "mac_address";
zci is_cached   => 1;

triggers startend => "mac address", "ethernet address";

my %oui_db = map { chomp; my (@f) = split(/\\n/, $_, 2); ($f[0] => $f[1]); } share("oui_database.txt")->slurp;

sub fmt_mac {
    my $mac = shift;
    $mac = lc($mac);
    $mac =~ s/..\K(?=.)/:/g;
    $mac;
}

sub build_infobox_element {
    my $query = shift;
    my @split = split ' ', $query;
    return {
        label => $query,
        url   => 'https://duckduckgo.com/?q=' . (join '+', @split) . '&ia=answer',
    };
}

my $infobox = [ { heading => "Related Queries", },
                build_infobox_element('generate mac address'),
                build_infobox_element('random mac address'),
              ];

handle remainder => sub {
    return unless $_;
    return unless $_ =~ m|^[-.:/ 0-9a-f]+$|i;
    $_ =~ s/[^0-9a-fA-F]//g;
    return unless (length($_) == 12 || length($_) == 16);

    my ($oui) = uc(substr($_, 0, 6));
    my ($info) = $oui_db{$oui};
    return unless $info;
    my ($name, $addr) = split(/\\n/, $info, 2);
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

    my $owner = shift @lines;
    my $text_answer = "The OUI, ".fmt_mac($oui).", for this NIC is assigned to $name";
    return $text_answer, structured_answer => {
        data => {
            title   => $owner,
            result => \@lines,
            input  => fmt_mac($_),
            infoboxData => $infobox
        },
        templates => {
            options => {
                content => 'DDH.mac_address.content',
            },
            group => 'text'
        }
    };
};

1;
