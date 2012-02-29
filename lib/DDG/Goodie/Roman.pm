package DDG::Goodie::Roman;

use DDG::Goodie;
use Roman;

triggers start => "roman", "arabic";

zci is_cached => 1;

handle remainder => sub {
    return uc(roman($_)) if $_ =~ /^\d+$/ && roman($_);
    return arabic $_ if lc($_) =~ /^[mdclxvi]+$/ && arabic($_);
    return;
};

1;
