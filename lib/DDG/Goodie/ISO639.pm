package DDG::Goodie::ISO639;
# ABSTRACT: ISO 639 language names and codes

use DDG::Goodie;
use Locale::Language;

triggers start => "iso 639", "iso639", "language code";

zci answer_type => "iso639";
zci is_cached => 1;

primary_example_queries 'iso639 english';
secondary_example_queries 'iso639 ab';
description 'lookup ISO639 language names and codes';
name 'ISO639';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ISO639.pm';
category 'reference';
topics 'programming';
attribution github => [ 'http://github.com/tantalor',  'John Tantalo' ],
            web    => [ 'http://johntantalo.com/blog', 'John Tantalo' ];


handle remainder => sub {
    my ($lang, $code) = langpair(shift) or return;
    return 'ISO 639: '. $lang .' - '. $code,
    structured_answer => {
        input => [$lang],
        operation => 'ISO 639 Language code',
        result => ($code),
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
