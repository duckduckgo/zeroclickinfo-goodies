use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'expression_description';
zci is_cached   => 1;

ddg_goodie_test(
    [
     'DDG::Goodie::BashPrimaryExpressions'
    ],
    "bash [ -a b ]" => test_zci(
    qr/.+ true if b exists./,
    structured_answer => {
        id => 'bash_primary_expressions',
        name => 'Answer',
        data => {
            intro => "[ -a b ]",
            results => [
                {
                    text => "true if ",
                    value => ""
                }, {
                    text => "",
                    value => "b"
                }, {
                    text => " exists",
                    value => ""
                }
            ]
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.bash_primary_expressions.content'
            }
        }
    }
    ),
    'bash [[ "abc" < "cba" ]]' => test_zci(
    qr/.+ true if "abc" string-sorts before "cba" in the current locale./,
    structured_answer => {
        id => 'bash_primary_expressions',
        name => 'Answer',
        data => '-ANY-',
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.bash_primary_expressions.content'
            }
        }
    }
    ),
    'bash [ 2 -gt 1 ]' => test_zci(
    qr/.+ true if 2 is numerically greater than 1./,
    structured_answer => {
        id => 'bash_primary_expressions',
        name => 'Answer',
        data => '-ANY-',
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.bash_primary_expressions.content'
            }
        }
    }
    ),
    'bash [ ! hello == world ]' => test_zci(
    qr/.+ false if the strings hello and world are equal./,
    structured_answer => {
        id => 'bash_primary_expressions',
        name => 'Answer',
        data => '-ANY-',
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.bash_primary_expressions.content'
            }
        }
    }
    ),
    'bash [[ /tmp/hello -nt /etc/test ]]' => test_zci (
    qr#.+ true if /tmp/hello has been changed more recently than /etc/test or if /tmp/hello exists and /etc/test does not.#,
    structured_answer => {
        id => 'bash_primary_expressions',
        name => 'Answer',
        data => '-ANY-',
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.bash_primary_expressions.content'
            }
        }
    }
    ),
    'bash [ -z hello ]' => test_zci(
        qr/.+ true if the length of 'hello' is zero./,
        structured_answer => {
        id => 'bash_primary_expressions',
        name => 'Answer',
        data => '-ANY-',
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.bash_primary_expressions.content'
            }
        }
    }
    ),
    'bash if [[ "abc" -lt "cba" ]]' => test_zci(
        qr/.+ true if "abc" is numerically less than "cba"./,
        structured_answer => {
        id => 'bash_primary_expressions',
        name => 'Answer',
        data => '-ANY-',
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.bash_primary_expressions.content'
            }
        }
    }
    ),
    'bash if [ 1 -lt 2 -a 1 -lt 3 ]' => undef,
    'bash if [ ![ 1 -lt 2 ] ]' => undef,
);

done_testing;
