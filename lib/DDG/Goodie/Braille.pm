package DDG::Goodie::Braille;
# ABSTRACT: Braille <-> ASCII/Unicode

use DDG::Goodie;

use Convert::Braille;

triggers query_raw => qr/\p{Braille}|braille/i;

zci is_cached => 1;

handle query_raw => sub {
    s/translate to braille |( in)? braille$|^braille //;
    return join(" ", map {lc(brailleDotsToAscii($_))} split(/\x{2800}/, $_)) . ' (Braille)' if /\p{Braille}/;
    # the space used in this join is not a normal space, it's a braille unicode space (U+2800)
    return join("\x{2800}", map {brailleAsciiToUnicode(uc $_)} split(/\s/, $_)) . ' (Braille)' if $_;
    return;
};

1;
