package DDG::Goodie::Reverse;
# ABSTRACT: Reverse the order of chars in the remainder

use strict;
use DDG::Goodie;

triggers startend => "reverse text";

zci answer_type => "reverse";
zci is_cached   => 1;

handle remainder => sub {
    my $in = $_;

    return if $in eq "";    # Guard against empty query.
    #Filter out requests for DNA/RNA reverse complements, handled
    # by the ReverseComplement goodie
    return if $in =~ /^complement\s(of )?[ATCGURYKMSWBVDHN\s-]+$/i;

    my $out = reverse $in;

    return qq|Reversed "$_": | . $out, structured_answer => {
        data => {
            title => $out,
            subtitle => "Reverse string: $in"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
