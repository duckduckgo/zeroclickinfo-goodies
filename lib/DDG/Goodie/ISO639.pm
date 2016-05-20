package DDG::Goodie::ISO639;
# ABSTRACT: ISO 639 language names and codes

use strict;
use DDG::Goodie;
use Locale::Language;

triggers start => "iso 639", "iso639", "language code";

zci answer_type => "iso639";
zci is_cached => 1;

handle remainder => sub {
    my ($lang, $code) = langpair(shift) or return;

    return "ISO 639: $lang - $code", structured_answer => {
        data => {
            title => $code,
            subtitle => "ISO 639 Language code: $lang"
        },
        templates => {
            group => 'text'
        }
    };
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
