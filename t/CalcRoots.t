#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'root';
zci is_cached => 1;

sub build_structured_answer {
    my ($exp, $base, $text, $html) = @_;
    return $text,
        structured_answer => {
            data => {
                title    => $html,
                subtitle => "Calculate $exp-root of $base",
            },
            templates => {
                group   => 'text',
                options => {
                    title_content => 'DDH.calc_roots.title',
                },
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::CalcRoots )],
    'square root of negative 9'           => build_test('2',  '-9',  'The 2-root of -9 is 3 i', '<sup>2</sup>&radic;-9 = 3<em>i</em>'),
    'negative square root of negative 25' => build_test('-2', '-25', 'The -2-root of -25 is -5 i', '-<sup>2</sup>&radic;-25 = -5<em>i</em>'),
    '2nd root of 100'                     => build_test('2',  '100', 'The 2-root of 100 is 10.',
            qq|<sup>2</sup>&radic;100 = <a href="javascript:;" onclick="document.x.q.value='10';document.x.q.focus();">10</a>|),
    'cube root of 33'                     => build_test('3',  '33',  'The 3-root of 33 is 3.20753432999583.',
            qq|<sup>3</sup>&radic;33 = <a href="javascript:;" onclick="document.x.q.value='3.20753432999583';document.x.q.focus();">3.20753432999583</a>|),
    '2nd root of 9999999999' => undef,
    'square root of minus garfield' => undef,
    'cubed root of pete' => undef,
    'negative root of dax the ducky' => undef,
);
done_testing;
