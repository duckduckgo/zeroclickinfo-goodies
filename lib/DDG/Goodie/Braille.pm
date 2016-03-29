package DDG::Goodie::Braille;
# ABSTRACT: Braille <-> ASCII/Unicode

use strict;
use DDG::Goodie;

use Convert::Braille;
use utf8;

triggers query_raw => qr/\p{Braille}|( in|to){1} braille$|^braille:/i;

zci is_cached => 1;

my $braille_space = '⠀';    # the braille unicode space (U+2800)

handle query_raw => sub {

    my $query = $_;
    $query =~ s/( in|to){1} braille$|^braille: //;
    return unless $query;

    my $result;
    my $type;

    if ($query =~ /\p{Braille}/) {
        $result = join(" ", map { lc(brailleDotsToAscii($_)) } split(/$braille_space/, $query));
        $type = "Ascii/Unicode";
    } else {
        $result = join($braille_space, map { brailleAsciiToUnicode(uc $_) } split(/\s/, $query));
        $type = "Braille";
    }

    return answer => $result,
      answer_type => $type,
      structured_answer => {
        input     => [$query],
        operation => 'Braille translation',
        result    => html_enc($result),
      };
};

1;
