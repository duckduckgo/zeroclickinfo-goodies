package DDG::Goodie::ChineseToPinyin;
# ABSTRACT: Get Pinyin of a Chinese string.

use strict;
use utf8;
use DDG::Goodie;
use Lingua::Han::PinYin;

zci answer_type => 'chinese_to_pinyin';
zci is_cached => 1;

triggers startend => 'pinyin', '拼音';


# FROM https://github.com/lilydjwg/winterpy/blob/master/pylib/pinyintone.py

# map (final) constanant+tone to tone+constanant
my %mapConstTone2ToneConst = ('n1' => '1n',
                              'n2' => '2n',
                              'n3' => '3n',
                              'n4' => '4n',
                              'ng1' => '1ng',
                              'ng2' => '2ng',
                              'ng3' => '3ng',
                              'ng4' => '4ng',
                              'r1' => '1r',
                              'r2' => '2r',
                              'r3' => '3r',
                              'r4' => '4r');

# map vowel+vowel+tone to vowel+tone+vowel
my %mapVowelVowelTone2VowelToneVowel = ('ai1' => 'a1i',
                                        'ai2' => 'a2i',
                                        'ai3' => 'a3i',
                                        'ai4' => 'a4i',
                                        'ao1' => 'a1o',
                                        'ao2' => 'a2o',
                                        'ao3' => 'a3o',
                                        'ao4' => 'a4o',
                                        'ei1' => 'e1i',
                                        'ei2' => 'e2i',
                                        'ei3' => 'e3i',
                                        'ei4' => 'e4i',
                                        'ou1' => 'o1u',
                                        'ou2' => 'o2u',
                                        'ou3' => 'o3u',
                                        'ou4' => 'o4u');

# map vowel-number combination to unicode
my %mapVowelTone2Unicode = ('a1' => 'ā',
                           'a2' => 'á',
                           'a3' => 'ǎ',
                           'a4' => 'à',
                           'e1' => 'ē',
                           'e2' => 'é',
                           'e3' => 'ě',
                           'e4' => 'è',
                           'i1' => 'ī',
                           'i2' => 'í',
                           'i3' => 'ǐ',
                           'i4' => 'ì',
                           'o1' => 'ō',
                           'o2' => 'ó',
                           'o3' => 'ǒ',
                           'o4' => 'ò',
                           'u1' => 'ū',
                           'u2' => 'ú',
                           'u3' => 'ǔ',
                           'u4' => 'ù',
                           'v1' => 'ǜ',
                           'v2' => 'ǘ',
                           'v3' => 'ǚ',
                           'v4' => 'ǜ');


# MAIN

handle remainder_lc => sub {
    # return if content if empty
    return if /^\s*$/;
    
    # return if already have special pinyin character
    return if /[āáǎàēéěèīíǐìōóǒòūúǔùǜǘǚǜ]/;
    
    # return unless content have Chinese character or have number (e.g. 測試/ce4 shi4)
    return unless /[\p{Han}0-9]/;
    
    
    $_ = trim($_);
    
    # add a space after every chinese character in order to separate pinyin
    my $spacedChineseString = $_ =~ s/(\p{Han})/$1 /rg;
    # remove space before any punctuation to prevent something like "hao3 ！"
    $spacedChineseString = $spacedChineseString =~ s/(\p{Han}) (\p{P})/$1$2/rg;
    
    my $h2p = new Lingua::Han::PinYin(tone => 1);
    my $result = $h2p->han2pinyin($spacedChineseString);
    $result = ConvertTone($result);
    
    # if content doesn't contain Chinese and result doesn't contain special Pinyin character
    return if (!(/[\p{Han}]/) and $result !~ m/[āáǎàēéěèīíǐìōóǒòūúǔùǜǘǚǜ]/);
    
    
    return "Pinyin of $_ is \"$result\"",
        structured_answer => {
        data => {
            title => "$result",
            subtitle => "Pinyin of $_"
        },
        templates => {
            group => 'text'
        }
    };
};


# sub: convert e.g. ni3 hao3 to nǐ hǎo

sub ConvertTone{
    print("Before convert tone: @_\n");
    
    # trim
    my $new = trim(@_);
    
    for my $key ( keys %mapConstTone2ToneConst ) {
        #print "$key: $mapConstTone2ToneConst{$key} \n";
        $new = $new =~ s/$key/$mapConstTone2ToneConst{$key}/rg;
    }
    for my $key ( keys %mapVowelVowelTone2VowelToneVowel ) {
        #print "$key: $mapVowelVowelTone2VowelToneVowel{$key} \n";
        $new = $new =~ s/$key/$mapVowelVowelTone2VowelToneVowel{$key}/rg;
    }
    for my $key ( keys %mapVowelTone2Unicode ) {
        #print "$key: $mapVowelTone2Unicode{$key} \n";
        $new = $new =~ s/$key/$mapVowelTone2Unicode{$key}/rg;
    }
    $new = $new =~ s/v/ü/rg;
    $new = $new =~ s/V/Ü/rg;
    print("After convert tone: $new\n");
    return "$new";
}

sub trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

1;