package DDG::Goodie::Braille;
# ABSTRACT: Braille <-> ASCII/Unicode

use DDG::Goodie;

use Convert::Braille;
use utf8;

triggers query_raw => qr/\p{Braille}|braille/i;

zci is_cached => 1;

my $braille_space = '⠀';    # the braille unicode space (U+2800)

handle query_raw => sub {

    my $query = $_;
    $query =~ s/translate to braille |( in)? braille$|^braille //;
    return unless $query;

    my $result;

    if ($query =~ /\p{Braille}/) {
        $result = join(" ", map { lc(brailleDotsToAscii($_)) } split(/$braille_space/, $query));
    } else {
        $result = join($braille_space, map { brailleAsciiToUnicode(uc $_) } split(/\s/, $query));
    }

    return $result . ' (Braille)',
      structured_answer => {
        input     => [html_enc($query)],
        operation => 'Braille translation',
        result    => html_enc($result),
      };
};

1;
