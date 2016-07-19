#!/usr/bin/env perl

use strict;
use warnings;
use utf8;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'morse';
zci is_cached   => 1;

my $sos  = '... --- ...';
my $duck = '.... . .-.. .-.. --- --..--  -.. ..- -.-. -.-';

sub build_test {
    my ($text, $title, $subtitle) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $title,
            subtitle => "Morse code conversion: $subtitle"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw(DDG::Goodie::Morse)],
    'morse code for ... --- ...'    => build_test("SOS", "SOS", $sos),
    'morse code for SOS'            => build_test($sos, $sos, "SOS"),
    'morse for SOS'                 => build_test($sos, $sos, "SOS"),
    'SOS to morse code'             => build_test($sos, $sos, "SOS"),
    'SOS to morse'                  => build_test($sos, $sos, "SOS"),
    'morse code for hello, duck'    => build_test($duck, $duck, "hello, duck"),
    'hello, duck to morse code'     => build_test($duck, $duck, "hello, duck"),
    'morse for hello, duck'         => build_test($duck, $duck, "hello, duck"),
    'hello, duck to morse'          => build_test($duck, $duck, "hello, duck"),
    'morse SOS'                     => undef,
    'morse code SOS'                => undef,
    'SOS morse'                     => undef,
    'SOS morse code'                => undef,
    'morse hello, duck'             => undef,
    'morse code hello, duck'        => undef,
    'morse code for cheatsheet'     => undef,
    'morse code for cheat sheet'    => undef,
);

done_testing;
