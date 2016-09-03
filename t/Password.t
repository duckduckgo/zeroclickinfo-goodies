#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'pw';
zci is_cached   => 0;

sub build_test {
    my ($chars, $strength) = @_;
    return test_zci(re(qr/^.{$chars} \(random password\)/), structured_answer => {
        data => {
            title => re(qr/^.{$chars}$/),
            subtitle => "Random password: $chars characters, $strength strength"
        }, 
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Password)],
    'pw 15 average' => build_test(15, 'average'),
    'password normal 15' => build_test(15, 'average'),
    'random pw 15 AVG' => build_test(15, 'average'),
    'pwgen strong 25' => build_test(25, 'high'),
    'password 25 hard' => build_test(25, 'high'),
    'Password High 25' => build_test(25, 'high'),
    # Example queries
    'random password' => build_test(8, 'average'),
    'password strong 15' => build_test(15, 'high'),
    'pw' => build_test(8, 'average'),
    # Add some triggers (issue  #1565)
    'generate password' => build_test(8, 'average'),
    'generate strong password' => build_test(8, 'high'),
    'generate random password' => build_test(8, 'average'),
    'password generator' => build_test(8, 'average'),
    'random password generator' => build_test(8, 'average'),
    'random strong password' => build_test(8, 'high'),
    'random password 16 characters' => build_test(16, 'average'),
    'create random password' => build_test(8, 'average'),
    'strong random password' => build_test(8, 'high'),
    'random password strong 15' => build_test(15, 'high'),
    'password 65' => undef,
    'random password weak 5' => undef,
    'password 5 EaSy' => undef,
    'password low 5' => undef,
    'generate generate password' => undef,
    'password pw' => undef,
    'password fortissimo' => undef,
    'nice random password' => undef,
    'excavate strong password' => undef,
    'not another strong pw' => undef,
    'generator' => undef,
    'potatoe generator' => undef
);

done_testing
