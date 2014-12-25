#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'random_passphrase';
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::Passphrase )],
    'random passphrase 1 word'          => test_zci(count_words(1)),
    'passphrase 1 word'                 => test_zci(count_words(1)),
    'passphrase 2 random word'          => test_zci(count_words(2)),
    'passphrase 2 word'                 => test_zci(count_words(2)),
    'passphrase 3 words random'         => test_zci(count_words(3)),
    'pass phrase 3 random words'        => test_zci(count_words(3)),
    'pass phrase 3 words random'        => test_zci(count_words(3)),
    '3 word passphrase'                 => test_zci(count_words(3)),
    '3 word pass phrase random'         => test_zci(count_words(3)),
    '4 word random passphrase'          => test_zci(count_words(4)),
    'generate 4 word random passphrase' => test_zci(count_words(4)),
    '10 word passphrase random'         => test_zci(count_words(10)),
    'random passphrase'                 => test_zci(count_words(4)),
    'create random passphrase'          => test_zci(count_words(4)),
    '3 random words passphrase'         => test_zci(count_words(3)),
    'random 3 word pass phrase'         => test_zci(count_words(3)),
    'pass phrase 3 words'               => test_zci(count_words(3)),
    'pass phrase 0 words'               => undef,
    'passphrase 11 words'               => undef,
    'passphrase 3'                      => undef,
    'passphrase'                        => undef,
    'pass phrase 3 chars'               => undef,
    'random generate 3 word passphrase' => undef,
);

sub count_words {
    my $count = shift;

    my $words_re = qr/(?:\s?\b[a-z]+\b){$count}/;

    return (
        qr/^random passphrase: $words_re$/,
        structured_answer => {
            input => [($count > 1) ? $count . ' words' : '1 word'],
            operation => 'random passphrase',
            result    => qr/^$words_re$/,
        });
}

done_testing;
