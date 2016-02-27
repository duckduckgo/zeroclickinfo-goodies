package DDG::Goodie::CaesarCipher;
# ABSTRACT: Perform a simple Caesar cipher on some text.

use strict;
use DDG::Goodie;

triggers startend => "caesar cipher",
                     "ceasar cipher",
                     "shift cipher";
triggers start => 'caesar', 'ceasar';

zci is_cached => 1;
zci answer_type => "caesar_cipher";

my @alphabet = ('a' ... 'z');

my $string_alphabet = join '', @alphabet;

sub build_infobox_element {
    my $query = shift;
    my @split = split ' ', $query;
    return {
        label => $query,
        url   => 'https://duckduckgo.com/?q=' . (join '+', @split) . '&ia=answer',
    };
}

my $infobox = [ { heading => "Example Queries", },
                build_infobox_element('caesar cipher 2 text'),
                build_infobox_element('shift cipher -2 vgzv'),
                build_infobox_element('caesar cipher 33 secret'),
                build_infobox_element('caesar cipher -7 zljyla'),
              ];

my @description_pars = split "\n\n",
    share('description.txt')->slurp();

my $decode_response = {
          id   => 'caesar_cipher',
          name => 'Answer',
          data => {
              title            => "How to decode the caesar cipher",
              infoboxData      => $infobox,
              description_pars => \@description_pars,
          },
          meta => {
              sourceUrl  => 'https://en.wikipedia.org/wiki/Caesar_cipher',
              sourceName => 'Wikipedia',
          },
          templates => {
              group   => 'info',
              options => {
                  content      => 'DDH.caesar_cipher.content',
                  chompContent => 1,
              },
          },
      };

sub wants_decode {
    my $query = shift;
    return $query =~ /^how to ((de|en)(code|crypt)|use)( (a|the))?|(de|en)(coder?|crypt(er)?)$/i;
}

sub perform_caesar {
    my ($to_cipher, $shift_val) = @_;

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
    return $result;
}

handle remainder => sub {
    my $remainder = shift;
    my $wants_decode = wants_decode($remainder);
    return "Caesar Cipher", structured_answer => $decode_response if $wants_decode;

    return unless $remainder =~ /(\-?\d+)\s+([[:ascii:]]+)$/;
    my ($shift_val, $to_cipher) = ($1, $2);

    my $result = perform_caesar($to_cipher, $shift_val);

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
