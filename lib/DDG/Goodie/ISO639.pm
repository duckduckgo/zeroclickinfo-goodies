package DDG::Goodie::ISO639;
# ABSTRACT: ISO 639 language names and codes

use DDG::Goodie;
use Locale::Language;

use constant WPHREF => "https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes";

triggers start => "iso 639", "iso639";

zci answer_type => "iso639";
zci is_cached => 1;

handle remainder => sub {
  my ($lang, $code) = langpair(shift) or return;
  my $text = sprintf qq(ISO 639: %s - %s), $lang, $code;
  my $html = sprintf qq(<a href="%s">ISO 639</a>: %s - %s), WPHREF, $lang, $code;
  return $text, html => $html;
};

sub langpair {

  if (my $lang = code2language($_)) {
    return ($lang, language2code($lang));
  }
  if (my $lang = code2language($_,'alpha-3')) {
    return ($lang, language2code($lang));
  }
  if (my $code = language2code($_)) {
    return (code2language($code), $code);
  }
  return;
}

1;
