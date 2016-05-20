#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "camel_case";
zci is_cached   => 1;

sub build_answer {
    my ($answer) = @_;
    
    return $answer, structured_answer => {
        data => {
            title => $answer,
            subtitle => 'camelCase'
        },
        templates => {
            group => 'text',
            moreAt => 1
        },
        meta => {
            sourceName => 'Wikipedia',
            sourceUrl => 'https://en.wikipedia.org/wiki/CamelCase'
        }
    }
}

ddg_goodie_test(
    [qw( DDG::Goodie::CamelCase )],
    'camelcase this is a test' => test_zci(build_answer('thisIsATest')),
    'camelcase this is another test' => test_zci(build_answer('thisIsAnotherTest')),
    
    'camel case this is a test' => test_zci(build_answer('thisIsATest')),
    'camel case this is another test' => test_zci(build_answer('thisIsAnotherTest')),
    
    'this is a test camelcase' => undef,
    'this is another test camelcase' => undef,
    
    'this is a test camel case' => undef,
    'this is another test camel case' => undef,
    
    'camelcase this' => undef
);

done_testing;
