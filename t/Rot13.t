#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'rot13';
zci is_cached   => 1;

sub build_answer {
    my ($text, $input, $answer) = @_; 
    return test_zci($text, structured_answer => {
        data => {
            title => $answer,
            subtitle => "ROT13: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Rot13 )],
    'rot13 This is a test' => build_answer('ROT13: Guvf vf n grfg', 'This is a test', 'Guvf vf n grfg'),
    'rot13 thirteen' => build_answer('ROT13: guvegrra', 'thirteen', 'guvegrra'),
    'rot13 guvegrra' => build_answer('ROT13: thirteen', 'guvegrra', 'thirteen'),
);

done_testing;
