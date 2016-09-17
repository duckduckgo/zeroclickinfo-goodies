#!/usr/bin/env perl

use strict;
use warnings;

# These modules are necessary for the functions we'll be running.
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

# These zci attributes aren't necessary, but if you specify them inside your
# goodie, you'll need to add matching values here to check against.
zci answer_type => 'password';
zci is_cached => 1;

ddg_goodie_test(
    [
        # This is the name of the goodie that will be loaded to test.
        'DDG::Goodie::RouterPasswords'
    ],
    # This is a sample query, just like the user will enter into the DuckDuckGo
    # search box.
    'Belkin f5d6130' =>
        test_zci(
            # The first argument to test_zci is the plain text (default)
            # returned from a goodie.  If your goodie also returns an HTML
            # version, you can pass that along explicitly as the second
            # argument. If your goodie is random, you can use regexs instead of
            # strings to match against.
            'Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130:<br><i>Username</i>: (none)<br><i>Password</i>: password'
        ),
    # You should include more test cases here. Try to think of ways that your
    # instant answer might break, and add them here to ensure they won't. Here are a
    # few others that were thought of for this goodie.
    'Belkin f5d6130 password default' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130:<br><i>Username</i>: (none)<br><i>Password</i>: password'),
    'default password Belkin f5d6130' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130:<br><i>Username</i>: (none)<br><i>Password</i>: password'),
    'Belkin f5d6130 password' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130:<br><i>Username</i>: (none)<br><i>Password</i>: password'),
    'default BELKIN password f5d6130' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130:<br><i>Username</i>: (none)<br><i>Password</i>: password'),
    'password bELKIN default f5d6130' =>
        test_zci('Default login for the BELKIN F5D6130: Username: (none) Password: password',
            html => 'Default login for the BELKIN F5D6130:<br><i>Username</i>: (none)<br><i>Password</i>: password'),
    'belkin f5d6130 default password' => test_zci(
        'Default login for the BELKIN F5D6130: Username: (none) Password: password',
        html => 'Default login for the BELKIN F5D6130:<br><i>Username</i>: (none)<br><i>Password</i>: password'
    ),
    'alcatel office 4200' => test_zci(
        'Default login for the ALCATEL OFFICE 4200: Username: n/a Password: password',
        html => 'Default login for the ALCATEL OFFICE 4200:<br><i>Username</i>: n/a<br><i>Password</i>: password'
    ),
);

# This function call is expected by Test::More. It makes sure the program
# doesn't exit before all the tests have been run.
done_testing;
