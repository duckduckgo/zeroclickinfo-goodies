package DDG::Goodie::SigFigs;
# ABSTRACT: Count the significant figures in a number.

use DDG::Goodie;

primary_example_queries 'sigfigs 01.1234000';
secondary_example_queries 'significant figures 000123000';
description 'return the count of significant figures in a number';
name 'Significant Figures';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SigFigs.pm';
category 'calculations';
topics 'math';

attribution github => ['https://github.com/hunterlang', 'hunterlang'];

triggers start => 'sigfigs', 'sigdigs', 'sf', 'sd', 'significant';

zci answer_type => "sig_figs";
zci is_cached => 1;

handle remainder => sub {
    $_ =~ s/^(figures|digits)\s*//g;
    return unless /^-?\d+(?:\.(?:\d+)?)?$/;
    $_ =~ s/-//;
    $_ =~ s/^0+//;
    my @arr = split('\\.', $_);
    my $v = @arr;
    my $len = 0;
    # there's a decimal
    unless ($v eq 1) {
        # the string doesn't have integers on the left
        # this means we can strip the leading zeros on the right
        if ($_ < 1) {
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
        $_ =~ s/\.?0*$//;
        $len = length $_;
    }
    return "Significant figures: $len";
};
1;
