#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'password';
zci is_cached => 1;

ddg_goodie_test(
	[qw(
		DDG::Goodie::RouterPasswords
	)],
	'Belkin f5d6130' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130: <i>Username</i>: (none) <i>Password</i>: password'),
	'Belkin f5d6130 default password' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130: <i>Username</i>: (none) <i>Password</i>: password'),
	'Belkin f5d6130 password default' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130: <i>Username</i>: (none) <i>Password</i>: password'),
	'default password Belkin f5d6130' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130: <i>Username</i>: (none) <i>Password</i>: password'),
	'Belkin f5d6130 password' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130: <i>Username</i>: (none) <i>Password</i>: password'),
	'default BELKIN password f5d6130' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130: <i>Username</i>: (none) <i>Password</i>: password'),
	'password bELKIN default f5d6130' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130: <i>Username</i>: (none) <i>Password</i>: password'),
);

done_testing;
