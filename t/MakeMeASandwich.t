#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'xkcd_sandwich';
zci is_cached   => 1;

my $yes = 'Okay.';
my $no = 'What? Make it yourself.';

sub build_test
{
    my ($text, $input) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $text,
            subtitle => [
                $input,
                { text => "XKCD 149", href => "https://duckduckgo.com/?q=xkcd%20149"}
            ]
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    ['DDG::Goodie::MakeMeASandwich'],
    'make me a sandwich'          => build_test($no, "make me a sandwich"),
    'MAKE ME A SANDWICH'          => build_test($no, "make me a sandwich"),
    'sudo make me a sandwich'     => build_test($yes, "sudo make me a sandwich"),
    'SUDO MAKE ME A SANDWICH'     => build_test($yes, 'sudo make me a sandwich'),
    'blahblah make me a sandwich' => undef,
    '0 make me a sandwich'        => undef,
);

done_testing;
