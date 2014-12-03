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
    romaji2kana
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

triggers query_lc => qr/^(?<text>.*?)(?: to| in)?\s+(?<syll>hiragana|katakana|romaji)$/;

my %dispatch = (
    'hiragana' => \&to_hiragana,
    'katakana' => \&to_katakana,
    'romaji'   => \&to_romaji
);

my $jp_punc = 'ー、。！？〜・「」｢｣『』〽0123456789';

sub trim_jp_punc {
    local $_ = shift @_;
    s/[\Q$jp_punc\E]//g;
    return $_;
};

sub to_hiragana {
    my $text = shift @_;
    return kata2hira($text) if is_kana(trim_jp_punc($text));
    return romaji2hiragana($text, { ime => 1 }) if is_romaji($text);
};

sub to_katakana {
    my $text = shift @_;
    return hira2kata($text) if is_kana(trim_jp_punc($text));
    return romaji2kana($text, { ime => 1 }) if is_romaji($text);
};

sub to_romaji {
    my $text = shift @_;
    kana2romaji($text, {style => 'hepburn', wo => 1}) if is_kana(trim_jp_punc($text));
};

handle query_lc => sub {
    my $text = $+{text};
    my $syll = $+{syll};
    my $answer = $dispatch{$syll}($text);
    return unless $answer;
    return $answer;
};

1;

