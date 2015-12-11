package DDG::Goodie::CaesarCipher;
# ABSTRACT: Perform a simple Caesar cipher on some text.

use strict;
use DDG::Goodie;

triggers start => "caesar cipher", "caesar",
                  "ceasar", "ceasar cipher";

zci is_cached => 1;
zci answer_type => "caesar_cipher";

primary_example_queries 'caesar cipher 3 cipher me';
secondary_example_queries 'caesar -1 Uijt jt b dbftbs djqifs';
description 'perform a simple Caesar cipher on some text';
name 'CaesarCipher';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CaesarCipher.pm';
category 'transformations';
topics 'cryptography';
attribution github => ['https://github.com/GuiltyDolphin', 'Ben Moon'];

handle remainder => sub {
    return unless $_ =~ /(\-?\d+)\s+([[:ascii:]]+)$/;
    my ($shift_val, $to_cipher) = ($1, $2);

    my $amount = $shift_val % 26;
    my @alphabet = ('a' ... 'z');
    my @second_alphabet = (@alphabet[$amount...25],
                           @alphabet[0..$amount-1]);
    my $alphabet = join '', @alphabet;
    my $result;
    foreach my $char (split //, $to_cipher) {
        if ($char =~ /[[:alpha:]]/) {
            my $uppercase = $char =~ /[A-Z]/;
            my $idx = index $alphabet, lc $char;
            $char = $second_alphabet[$idx] if ($idx != -1);
            $char = uc $char if ($uppercase);
        }
        $result .= $char;
    }

    return "$result",
      structured_answer => {
        input     => ["$shift_val", "$to_cipher"],
        operation => 'Caesar cipher',
        result    => html_enc($result),
      };
};

1;
