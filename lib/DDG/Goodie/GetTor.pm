package DDG::Goodie::GetTor;
# ABSTRACT: Tips to get the Tor Browser and bridges for places where access to Tor Project's website is blocked.

use strict;
use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "get_tor";

primary_example_queries 'get tor browser';
secondary_example_queries 'get bridges';
description "Tips to get the Tor Browser and bridges for places where access to Tor Project's website is blocked.";
name 'GetTor';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/GetTor.pm';
category 'special';
topics 'social', 'special_interest', 'cryptography';
attribution email => 'ilv@torproject.org';

# this triggers should cover the space search for someone that wants to
# download the Tor Browser or get some bridges
triggers any => 'gettor',
                'get tor',
                'gettor browser',
                'gettor bridges',
                'get bridges',
                'tor bridges',
                'tor browser',
                'torbrowser';

handle query_lc => sub {
    my $html_output = "<div class='zci__caption'>";

    if ($_ =~ m/bridges?/) {
        $html_output .= "Send a blank email to* <strong>bridges\@torproject.org</strong> and you will receive instructions";
        $html_output .= " on how to get some bridges.</div>";
        # this restriction is related to DKIM, so it's unlikely to change in the future
        $html_output .= "<em>*From Riseup, Gmail, or Yahoo accounts only.</em>";
        return 'bridges', html => $html_output;
    } else {
        $html_output .= "Send a blank email to <strong>gettor\@torproject.org</strong> and you will receive instructions";
        $html_output .= " to download Tor Browser from popular cloud services.</div>";
        return 'torbrowser', html =>  $html_output;
    }
};

1;
