use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'combination';
zci is_cached => 1;

ddg_goodie_test(
    [
        'DDG::Goodie::Combinations'
    ],
    # This is a sample query, just like the user will enter into the DuckDuckGo search box
    # 'Belkin f5d6130' =>
    #     test_zci(
    #         # The first argument to test_zci is the plain text (default) returned from a goodie.
    #         # If your goodie also returns an HTML version, you can pass that along explicitly as
    #         # the second argument. If your goodie is random, you can use regexs instead of
    #         # strings to match against.
    #         'Default login for the BELKIN F5D6130: Username: (none) Password: password',
    #         html => 'Default login for the BELKIN F5D6130:<br><i>Username</i>: (none)<br><i>Password</i>: password'
    #     ),
    ' 5 choose 3' => test_zci('5 choose 3 = 10'),
    '5 choose 3 ' => test_zci('5 choose 3 = 10'),
    ' 5 choose 3 ' => test_zci('5 choose 3 = 10'),
    '7 choose 0' => test_zci('7 choose 0 = 1'),
    '0 choose 3' => test_zci('0 choose 3 = 0'),
    "-1 choose -2" =>
    # You should include more test cases here. Try to think of ways that your plugin
    # might break, and add them here to ensure they won't.
);

done_testing;