package DDG::Goodie::Kana;
# ABSTRACT: Convert katakana, hiragana or romaji texts between each other

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

zci is_cached   => 1;
zci answer_type => 'kana';

triggers end => qw/hiragana katakana romaji/;

my %dispatch = (
    'hiragana' => \&to_hiragana,
    'katakana' => \&to_katakana,
    'romaji'   => \&to_romaji
);

my $jp_punc = '｛｝（）［］【】、，…。・「」『』〜：！？0123456789 ー';
my $punc = '{}()[][],,….•\'\'""~:!?0123456789 -';

# Removes all puncuations symbols
# Methods from Lingua::JA::Moji don't work with it
sub trim_punc {
    local $_ = shift @_;
    my $punc = shift @_;
    s/[\Q$punc\E]//g;
    return $_;
};

# Translates punctuation between each other
sub punc_from_jp {
    local $_ = shift @_;
    eval "tr/$jp_punc/$punc/";
    return $_;
}

sub punc_to_jp {
    local $_ = shift @_;
    eval "tr/$punc/$jp_punc/";
    return $_;
}

# From romaji or kana to hiragana
sub to_hiragana {
    my $text = shift @_;
    return kata2hira($text) if is_kana(trim_punc($text, $jp_punc));
    return romaji2hiragana(punc_to_jp($text), { ime => 1 }) if is_romaji(trim_punc($text, $punc));
};

# From romaji or kana to katakana
sub to_katakana {
    my $text = shift @_;
    return hira2kata($text) if is_kana(trim_punc($text, $jp_punc));
    return romaji2kana(punc_to_jp($text), { ime => 1 }) if is_romaji(trim_punc($text, $punc));
};

# From kana to romaji
sub to_romaji {
    my $text = shift @_;
    my $romaji = kana2romaji($text, {style => 'hepburn', wo => 1}) if is_kana(trim_punc($text, $jp_punc));
    return unless $romaji;
    punc_from_jp($romaji);
};

handle query_lc => sub {
    return unless /^
        (?<text>.*?)
        (?: to| in)?\s+
        (?<syll>hiragana|katakana|romaji)
        $/x;

    my $text = $+{text};
    my $syll = $+{syll}; # Output syllable
    $text =~ s/^\s+|\s+$//g;
    my $answer = $dispatch{$syll}($text);

    return unless $answer;

    return "$text converted to $syll is $answer",
        structured_answer => {
            input     => [$text],
            operation => "Convert to ". ucfirst $syll,
            result    => $answer
        };
};

1;

