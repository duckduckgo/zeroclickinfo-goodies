package DDG::Goodie::ISO639;
# ABSTRACT: ISO 639 language names and codes

use DDG::Goodie;
use Locale::Language;

use constant WPHREF => "https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes";

zci answer_type => "language";

# TODO: support "iso 639" and "iso-639"
triggers start => "iso639";

handle remainder => sub {
  my ($lang, $code) = langpair(shift) or return;
  my $text = sprintf qq(%s (ISO 639-1 %s)), $lang, $code;
  my $html = sprintf qq(%s (<a href="%s">ISO 639-1 %s</a>)), $lang, WPHREF, $code;
  return $text, html => $html;
};

sub langpair {
  if (my $lang = code2language($_)) {
    return ($lang, language2code($lang));
  }
  if (my $code = language2code($_)) {
    return (code2language($code), $code);
  }
  return;
}

zci is_cached => 1;

1;
