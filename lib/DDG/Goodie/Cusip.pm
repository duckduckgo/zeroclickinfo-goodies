package DDG::Goodie::Cusip;
# ABSTRACT: Validate a CUSIP ID's check digit.

use strict;
use DDG::Goodie;
use Business::CUSIP;
use Text::Trim;

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
        $output = "$_ is a properly formatted CUSIP number";
    } else {
        $output = "$_ is not a properly formatted CUSIP number";
    }

    # output results
    return $output,
    structured_answer => {
        data => {
            title => $output,
        },
        templates => {
            group => 'text',
        }
    };
};

1;
