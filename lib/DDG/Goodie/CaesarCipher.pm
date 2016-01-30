package DDG::Goodie::CaesarCipher;
# ABSTRACT: Perform a simple Caesar cipher on some text.

use strict;
use DDG::Goodie;

triggers start => "caesar cipher", "caesar",
                  "ceasar", "ceasar cipher",
                  "shift cipher";

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


my @alphabet = ('a' ... 'z');

my $string_alphabet = join '', @alphabet;

handle remainder => sub {
    return unless $_ =~ /(\-?\d+)\s+([[:ascii:]]+)$/;
    my ($shift_val, $to_cipher) = ($1, $2);

    my $amount = $shift_val % 26;
    # This creates the cipher by shifting the alphabet.
    my @shifted_alphabet = (@alphabet[$amount...25],
                            @alphabet[0..$amount-1]);
    my $result;
    foreach my $char (split //, $to_cipher) {
        if ($char =~ /[[:alpha:]]/) {
            my $uppercase = $char =~ /[A-Z]/;
            my $idx = index $string_alphabet, lc $char;
            $char = $shifted_alphabet[$idx] if ($idx != -1);
            $char = uc $char if ($uppercase);
        }
        $result .= $char;
    }

    return "$result",
      structured_answer => {
          id   => 'caesar_cipher',
          name => 'Answer',
          data => {
              title    => "$result",
              subtitle => html_enc("Caesar cipher $shift_val $to_cipher"),
          },
          templates => {
              group  => 'text',
              moreAt => 0,
          },
      };
};

1;
