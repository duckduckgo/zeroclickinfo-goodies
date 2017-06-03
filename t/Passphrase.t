#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'random_passphrase';
zci is_cached   => 0;

sub count_words {
    my $count = shift;

    my $words_re = qr/(?:\s?\b[a-z\-]+\b){$count}/;

    return test_zci(re(qr/^random passphrase: $words_re$/), structured_answer => {
        data => {
            title => re(qr/^$words_re$/),
            subtitle => "Random passphrase: $count " . ($count==1 ? "word":"words")
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Passphrase )],
    'random passphrase 1 word'          => count_words(1),
    'passphrase 1 word'                 => count_words(1),
    'passphrase 2 random word'          => count_words(2),
    'passphrase 2 word'                 => count_words(2),
    'passphrase 3 words random'         => count_words(3),
    'pass phrase 3 random words'        => count_words(3),
    'pass phrase 3 words random'        => count_words(3),
    '3 word passphrase'                 => count_words(3),
    '3 word pass phrase random'         => count_words(3),
    '4 word random passphrase'          => count_words(4),
    'generate 4 word random passphrase' => count_words(4),
    '10 word passphrase random'         => count_words(10),
    'passphrase'                        => count_words(4),
    'random passphrase'                 => count_words(4),
    'random pass phrase'                => count_words(4),
    'passphrase random'                 => count_words(4),
    'pass phrase random'                => count_words(4),
    'generate random passphrase'        => count_words(4),
    'create random passphrase'          => count_words(4),
    'create passphrase random'          => count_words(4),
    '3 random words passphrase'         => count_words(3),
    'random 3 word pass phrase'         => count_words(3),
    'pass phrase 3 words'               => count_words(3),
    'pass phrase 0 words'               => undef,
    'passphrase 11 words'               => undef,
    'passphrase 3'                      => undef,
    'pass phrase 3 chars'               => undef,
    'random generate 3 word passphrase' => undef,
);

done_testing;
