package DDG::Goodie::Braille;

use DDG::Goodie;
use Convert::Braille;
use Convert::Braille::English;

triggers query_raw => qr/\p{Braille}|braille/i;

zci is_cached => 1;

handle query_raw => sub {
    s/ in braille$|^braille (translate (to )?)?//;
    return lc(brailleDotsToEnglish($_)) . ' (Braille)' if /\p{Braille}/;
    return brailleAsciiToUnicode(uc $_) . ' (Braille)' if $_;
    return;
};

1;
