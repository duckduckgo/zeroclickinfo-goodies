package DDG::Goodie::SigFigs;
# ABSTRACT: Count the significant figures in a number.

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

triggers start => 'sigfigs', 'sigdigs', 'sf', 'sd', 'significant';

zci answer_type => "sig_figs";
zci is_cached => 1;

handle remainder => sub {
    my $query = $_;
    $query =~ s/^(figures|digits)\s*//;
    my $style = number_style_for($query);
    return unless $style;
    my $formatted_input = $style->for_display($query);
    my $to_compute = $style->for_computation($query);
    my $digits = $to_compute =~ s/^[-+]//r;
    # Leading digits NEVER contribute towards significant figures.
    $digits =~ s/^0+//;
    my @arr = split('\\.', $digits);
    my $v = @arr;
    my $len = 0;
    # there's a decimal
    unless ($v eq 1) {
        # the string doesn't have integers on the left
        # this means we can strip the leading zeros on the right
        if ($digits < 1) {
            $arr[1] =~ s/^0+//;
            $len = length $arr[1];
        }
        #there are integers on the left
        else {
            $len = length($arr[0]) + length($arr[1]);
        }
    }
    # no decimal
    else {
        # lose the trailing zeros and count
        $digits =~ s/\.?0*$//;
        $len = length $digits;
    }
    return $len, structured_answer => {
        id   => 'sig_figs',
        name => 'Answer',
        data => {
            title    => "$len",
            subtitle => "Significant figures of $formatted_input",
        },
        templates => {
            group  => 'text',
            moreAt => 0,
        },
    };
};
1;
