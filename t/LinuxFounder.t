#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "linux_founder";
zci is_cached   => 1;

my $answer = "Linus Torvalds is the founder and creator of Linux";

ddg_goodie_test(
    [qw( DDG::Goodie::LinuxFounder )],

    # Good Tests
    'linux founder' => test_zci($answer, 
        structured_answer => {
            input => ["Linux Founder"],
            operation => "Answer",
            result => "Linus Torvalds"
        }
    ),
    
    'founder of linux' => test_zci($answer, 
        structured_answer => {
            input => ["Linux Founder"],
            operation => "Answer",
            result => "Linus Torvalds"
        }
    ),
    
    # Bad Tests
    'who is the founder of the linux fsdjklfsd' => undef,
    'fhdsjka linux founder' => undef,
    'linux asdfhjk founder' => undef
);

done_testing;
