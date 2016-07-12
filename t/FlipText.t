#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'flip_text';
zci is_cached   => 1;

sub build_structured_answer{
    my ($input,$result) = @_;
    return $result,
    structured_answer => {
        data => {
            title    => $result,
            subtitle => "Flip text $input"
        },
        templates => {
            group => 'text',
        }
    }
}

sub build_test{ test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::FlipText)],
    'flip text test'            => build_test('test','ʇsǝʇ'),
    'mirror text test'          => build_test('test','ʇsǝʇ'),
    'flip text my sentence'     => build_test('my sentence','ǝɔuǝʇuǝs ʎɯ'),
    'mirror text text'          => build_test('text','ʇxǝʇ'),
    'flip text <hello-world>'   => build_test('<hello-world>','<pʃɹoʍ-oʃʃǝɥ>'),
    'rotate text "hello world"' => build_test('"hello world"','„pʃɹoʍ oʃʃǝɥ„'),
    'spin text ;hello world;'   => build_test(';hello world;','؛pʃɹoʍ oʃʃǝɥ؛'),
    'spin text [\'hello\']'     => build_test('[\'hello\']','[,oʃʃǝɥ,]'),
    'spin text <<"hello\' % & * () = + . #@!^(/world">>' => build_test('<<"hello\' % & * () = + . #@!^(/world">>','<<„pʃɹoʍ/)∨¡@# ˙ + = () ⁎ ⅋ % ,oʃʃǝɥ„>>'),
    
    'photoshop flip text' => undef
);

done_testing;
