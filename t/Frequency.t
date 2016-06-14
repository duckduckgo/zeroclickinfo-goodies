#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci is_cached => 1;
zci answer_type => 'frequency';

my @structured_answer = {
    data => ignore(),
    templates => {
        group => "list",
        options => {
            content => "record"
        }
    }
};

my $title = "Frequency";
my @templates = {
    group => "list",
    options => {
        content => "record"
    }
};

ddg_goodie_test(
        [qw(
                DDG::Goodie::Frequency
        )],

    "frequency of all in test" => test_zci(
        "e:1/4 s:1/4 t:2/4",
        structured_answer => {
            data => {
                title => $title,
                record_data => {
                    'e' => 1,
                    's' => 1,
                    't' => 2
                },
                record_keys => ['e', 's', 't']
            },
            templates => @templates
        }
    ),

    'frequency of all letters in test' => test_zci(
        'e:1/4 s:1/4 t:2/4',
        structured_answer => {
            data => {
                title => $title,
                record_data => {
                    'e' => 1,
                    's' => 1,
                    't' => 2
                },
                record_keys => ['e', 's', 't']
            },
            templates => @templates
        }
    ),

    'frequency of letters in test' => test_zci(
        'e:1/4 s:1/4 t:2/4',
        structured_answer => {
            data => {
                title => $title,
                record_data => {
                    'e' => 1,
                    's' => 1,
                    't' => 2
                },
                record_keys => ['e', 's', 't']
            },
            templates => @templates
        }
    ),

    'frequency of all characters in test' => test_zci(
        'e:1/4 s:1/4 t:2/4',
        structured_answer => {
            data => {
                title => $title,
                record_data => {
                    'e' => 1,
                    's' => 1,
                    't' => 2
                },
                record_keys => ['e', 's', 't']
            },
            templates => @templates
        }
    ),

    'frequency of all chars in test' => test_zci(
        'e:1/4 s:1/4 t:2/4',
        structured_answer => {
            data => {
                title => $title,
                record_data => {
                    'e' => 1,
                    's' => 1,
                    't' => 2
                },
                record_keys => ['e', 's', 't']
            },
            templates => @templates
        }
    ),

    'frequency of all in testing 1234 ABC!' => test_zci(
        'a:1/10 b:1/10 c:1/10 e:1/10 g:1/10 i:1/10 n:1/10 s:1/10 t:2/10',
        structured_answer => {
            data => {
                title => $title,
                record_data => {
                    'a' => 1,
                    'b' => 1,
                    'c' => 1,
                    'e' => 1,
                    'g' => 1,
                    'i' => 1,
                    'n' => 1,
                    's' => 1,
                    't' => 2
                },
                record_keys => ['a', 'b', 'c', 'e', 'g', 'i', 'n', 's', 't']
            },
            templates => @templates
        }
    ),

    'frequency of a in Atlantic Ocean' => test_zci(
        'a:3/13',
        structured_answer => {
            data => {
                title => $title,
                record_data => {
                    "a" => 3
                },
                record_keys => ["a"]
            },
            templates => @templates
        }
    ),

    'freq of B in battle' => test_zci(
        'b:1/6',
        structured_answer => {
            data => {
                title => $title,
                record_data => {
                    'b' => 1
                },
                record_keys => ['b']
            },
            templates => @templates
        }
    ),

    'freq of s in Spoons' => test_zci(
        's:2/6',
        structured_answer => {
            data => {
                title => $title,
                record_data => {
                    's' => 2
                },
                record_keys => ['s']
            },
            templates => @templates
        }
    ),

    'frequency s in spoons' => undef,
    'freq s in spoons' => undef,
    'frequency s spoons' => undef,
    'freq s spoons' => undef,
    'frequency of s spoons' => undef,
    'freq of s spoons' => undef

);

done_testing;
