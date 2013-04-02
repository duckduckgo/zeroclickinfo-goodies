package DDG::Goodie::Braille;

use DDG::Goodie;
use Convert::Braille;

triggers any => "braille";

zci is_cached => 1;

handle query_raw => sub {
    s/( in braille$)| ?braille ?//g;
    return brailleAsciiToUnicode(uc $_) . ' (Braille)' if $_;
    return;
};

1;
