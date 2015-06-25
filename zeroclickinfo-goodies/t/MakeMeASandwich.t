#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'xkcd_sandwich';
zci is_cached   => 1;

my @yes = (
    'Okay.',
    structured_answer => {
        input     => ['sudo make me a sandwich'],
        operation => '<a href="https://duckduckgo.com/?q=xkcd%20149">xkcd 149</a>',
        result    => 'Okay.'
    });
my @no = (
    'What? Make it yourself.',
    structured_answer => {
        input     => ['make me a sandwich'],
        operation => '<a href="https://duckduckgo.com/?q=xkcd%20149">xkcd 149</a>',
        result    => 'What? Make it yourself.'
    });

ddg_goodie_test(
    ['DDG::Goodie::MakeMeASandwich'],
    'make me a sandwich'          => test_zci(@no),
    'MAKE ME A SANDWICH'          => test_zci(@no),
    'sudo make me a sandwich'     => test_zci(@yes),
    'SUDO MAKE ME A SANDWICH'     => test_zci(@yes),
    'blahblah make me a sandwich' => undef,
    '0 make me a sandwich'        => undef,
);

done_testing;
