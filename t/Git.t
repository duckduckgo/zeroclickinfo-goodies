#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "git";
zci is_cached   => 1;

# This goodie always returns the same answer whenever its triggered
my $test_zci = test_zci(qr/.*/s ,
                        heading => "Git Commands Cheat Sheet",
                           html => qr/.*/s,);

ddg_goodie_test(
    ['DDG::Goodie::Git'],
    "git cheat sheet"     => $test_zci,
    "cheat sheet git"     => $test_zci,
    "git cheatsheet"      => $test_zci,
    "cheatsheet git"      => $test_zci,
    "git help"            => $test_zci,
    "help git"            => $test_zci,
    "git quick reference" => $test_zci,
    "quick reference git" => $test_zci,
    "git reference"       => $test_zci,
    "reference git"       => $test_zci,
);

done_testing;
