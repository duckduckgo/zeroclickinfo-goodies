package DDG::Goodie::Kana;
# ABSTRACT: Convert katakana, hiragan or romaji texts between each other

use utf8;
use DDG::Goodie;
use Lingua::JA::Moji qw/
    is_kana
    is_romaji
    is_hiragana
    hira2kata
    kata2hira
    kana2romaji
    romaji2hiragana/;

name                        'Kana';
topics                      'special_interest';
category                    'language';
attribution                  github => ['http://github.com/hradecek', 'hradecek'];
description                 'Convert texts writen in kana to romaji;' .
                            'romaji to katakana or hiragana; '.
                            'hiragana to katakana or vice versa';
primary_example_queries     'カひらがなタカナ romaji',
                            'ahiru katakana',
                            'ahiru hiragana';
secondary_example_queries   'ahiru to hiragana',
                            'ahiru in hiragana';

zci is_cached   => 1;
zci answer_type => 'kana';

triggers query_lc => qr//;

handle query_raw => {
};

1;

