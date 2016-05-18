#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "rc4";
zci is_cached   => 1;

sub build_test {
    my ($text, $title, $subtitle) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $title,
            subtitle => $subtitle
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw(
        DDG::Goodie::Rc4
    )],
    'rc4 en mysecretkey hello' => build_test("RC4 Encrypt: hello, with key: mysecretkey is grYU1K8=", "grYU1K8=", "RC4 Encrypt: hello, Key: mysecretkey"),
	'rc4 de duck yWrJniG/nNg=' => build_test("RC4 Decrypt: yWrJniG/nNg=, with key: duck is DdgRocks", "DdgRocks", "RC4 Decrypt: yWrJniG/nNg=, Key: duck"),
    'rc4 ' => undef,
    'rc4 enc missing' => undef,
    'rc4 no operation' => undef
);

done_testing;
