use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'password';
zci is_cached => 1;

sub build_router_answer {
    my @test_params = @_;

    return re(qr/^(?!\s*$).+/),
        structured_answer => {
            data => {
                title => re(qr/\w/),
                subtitle => re(qr/\w/)
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
    'Belkin f5d6130 password default' => build_router_test(),
    'default password Belkin f5d6130' => build_router_test(),
    'Belkin f5d6130 password' => build_router_test(),
    'default BELKIN password f5d6130' => build_router_test(),
    'alcatel office 4200' => build_router_test(),
);

done_testing;
