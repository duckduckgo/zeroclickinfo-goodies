#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'pw';
zci is_cached   => 0;

sub build_test {
	my ($answer, $input) = @_;
	
	return test_zci($answer, structured_answer => {
		data => {
			title => $answer,
			subtitle => "Random password: $input"
		}, 
		templates => {
			group => 'text'
		}
	});
}

ddg_goodie_test(
    [qw( DDG::Goodie::Password)],
    'pw 15 average' => build_test(re(qr/.{15}/), '15 characters, average strength'),
    'password normal 15' => build_test(re(qr/.{15}/), '15 characters, average strength'),
    'random pw 15 AVG' => build_test(re(qr/.{15}/), '15 characters, average strength'),
    'pwgen strong 25' => build_test(re(qr/.{25}/), '25 characters, high strength'),
    'password 25 hard' => build_test(re(qr/.{25}/), '25 characters, high strength'),
    'Password High 25' => build_test(re(qr/.{25}/), '25 characters, high strength'),
    # Example queries
    'random password' => build_test(re(qr/.{8}/), '8 characters, average strength'),
    'password strong 15' => build_test(re(qr/.{15}/), '15 characters, high strength'),
    'pw' => build_test(re(qr/.{8}/), '8 characters, average strength'),
    # Add some triggers (issue  #1565)
    'generate password' => build_test(re(qr/.{8}/), '8 characters, average strength'),
    'generate strong password' => build_test(re(qr/.{8}/), '8 characters, high strength'),
    'generate random password' => build_test(re(qr/.{8}/), '8 characters, average strength'),
    'password generator' => build_test(re(qr/.{8}/), '8 characters, average strength'),
    'random password generator' => build_test(re(qr/.{8}/), '8 characters, average strength'),
    'random strong password' => build_test(re(qr/.{8}/), '8 characters, high strength'),
    'random password 16 characters' => build_test(re(qr/.{16}/), '16 characters, average strength'),
    'create random password' => build_test(re(qr/.{8}/), '8 characters, average strength'),
    'strong random password' => build_test(re(qr/.{8}/), '8 characters, high strength'),
    'random password strong 15' => build_test(re(qr/.{15}/), '15 characters, high strength'),
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
