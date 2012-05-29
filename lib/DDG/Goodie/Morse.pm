package DDG::Goodie::Morse;
# ABSTRACT: Converts to/from Morse code

use DDG::Goodie;
use Convert::Morse qw(is_morse as_ascii as_morse);

attribution
  web     => 'http://und3f.com',
  twitter => 'und3f',
  github  => 'und3f',
  cpan    => 'UNDEF';

triggers start => 'morse';

zci is_cached => 1;
zci answer_type => 'chars';

handle remainder => sub {
    return unless $_;

    my $convertor = is_morse($_) ? \&as_ascii : \&as_morse;
    return "Morse: " . $convertor->($_);
};

1;
