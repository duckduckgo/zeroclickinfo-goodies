#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'convert_to_ascii';
zci is_cached => 1;

sub build_test {
    my ($decoded) = @_;
    return test_zci($decoded, structured_answer => {
        data => {
            title => $decoded
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw(
        DDG::Goodie::Unidecode
	)],
    "unidecode møæp"  => build_test('moaep'),
    "unidecode \x{5317}\x{4EB0}" => build_test('Bei Jing'),
    "unidecode åäº°" => build_test('aaodeg'),
);

done_testing;
