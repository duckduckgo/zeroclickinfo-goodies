package DDG::Goodie::PercentError;
# ABSTRACT: find the percent error given accepted and experimental values

use strict;
use DDG::Goodie;

triggers start => "percent error", "% error", "%err", "%error", "percenterror", "percent err", "%-error";

zci answer_type => "percent_error";
zci is_cached => 1;

handle remainder => sub {
    my $length = length($_);

    my ( $acc, $exp ) = split /\s*[\s;,]\s*/, $_;
    return unless $acc =~ /^-?\d+?(?:\.\d+|)$/ && $exp =~ /^-?\d+?(?:\.\d+|)$/;

    my $diff = abs $acc - $exp;
    my $per = abs ($diff/$acc);
    my $err = $per*100;
    
    return "Accepted: $acc Experimental: $exp Error: $err%",
    structured_answer => {
        data => {
            title => "Error: $err%",
            subtitle => "Accepted: $acc Experimental: $exp",
        },
        templates => {
            group => 'text',
        }
    };
};

1;
