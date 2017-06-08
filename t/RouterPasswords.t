use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'password';
zci is_cached => 1;

sub build_router_answer {
    my ($router, $user, $password)  = @_;
    $router = uc $router;

    return 'Default login for the ' . $router . ': Username: ' . $user . ' Password: ' . $password,
        structured_answer => {
            data => {
                title => $password,
                subtitle => 'Router: ' . $router . ' | Username: ' . $user . ' | Password: ' . $password
            },
            templates => {
                group => "text",
            }
        };
}

sub build_router_test { test_zci(build_router_answer(@_)) }

ddg_goodie_test(
    [
        'DDG::Goodie::RouterPasswords'
    ],
    'Belkin f5d6130 password default' => build_router_test('Belkin f5d6130', '(none)', 'password'),
    'default password Belkin f5d6130' => build_router_test('Belkin f5d6130', '(none)', 'password'),
    'Belkin f5d6130 password' => build_router_test('Belkin f5d6130', '(none)', 'password'),
    'default BELKIN password f5d6130' => build_router_test('Belkin f5d6130', '(none)', 'password'),
    'password bELKIN default f5d6130' => build_router_test('Belkin f5d6130', '(none)', 'password'),
    'belkin f5d6130 default password' => build_router_test('Belkin f5d6130', '(none)', 'password'),
    'alcatel office 4200' => build_router_test('alcatel office 4200', 'n/a', 'password'),
);

done_testing;
