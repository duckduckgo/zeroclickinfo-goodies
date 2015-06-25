package DDG::Goodie::Cusip;
# ABSTRACT: Validate a CUSIP ID's check digit.

use strict;
use DDG::Goodie;
use Business::CUSIP;
use Text::Trim;

# metadata
name "CUSIP check";
description "Validates the check digit for a unique stock identifier based on the Committee on Uniform Securities Identification Procedures";
primary_example_queries "cusip 037833100";
secondary_example_queries "cusip check 38259P706", "844741108 cusip check";
category "finance";
topics "economy_and_finance";
code_url "https://github.com/tommytommytommy/zeroclickinfo-goodies/lib/DDG/Goodie/Cusip.pm";
attribution github => ["https://github.com/tommytommytommy", 'tommytommytommy'];

triggers startend => "cusip", "check cusip", "cusip check";

zci answer_type => "cusip";

# magic number to identify the length of the CUSIP ID
my $CUSIPLENGTH = 9;

handle remainder => sub {

    # capitalize all letters in the CUSIP
    $_ = uc trim $_;

    # check that the remainder is the correct length and
    # only contains alphanumeric chars and *, @, and #
    return if not m/^[A-Z0-9\*\@\#]{$CUSIPLENGTH}$/;

    my $cusip = Business::CUSIP->new($_);
    my ($output, $htmlOutput);

    if ($cusip->is_valid) {
        $output = html_enc($_)." is a properly formatted CUSIP number.";
        $htmlOutput = "<div class='zci--cusip text--primary'>".html_enc($_)." is a properly formatted <span class='text--secondary'>CUSIP number.</span></div>";
    } else {
        $output = html_enc($_)." is not a properly formatted CUSIP number.";
        $htmlOutput = "<div class='zci--cusip text--primary'>".html_enc($_)." is not a properly formatted <span class='text--secondary'>CUSIP number.</span></div>";
    }

    # output results
    return $output, html => $htmlOutput;
};

1;
