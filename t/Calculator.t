#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'calc';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::Calculator )],
        'what is 2-2' => test_zci(
            "2 - 2 = 0",
            heading => 'Calculator',
            html => qq(<div>2 - 2 = <a href="javascript:;" onClick="document.x.q.value='0';document.x.q.focus();">0</a></div>)
        ),
        'solve 2+2' => test_zci(
            "2 + 2 = 4",
            heading => 'Calculator',
            html => qq(<div>2 + 2 = <a href="javascript:;" onClick="document.x.q.value='4';document.x.q.focus();">4</a></div>)
        ),
        '2^8' => test_zci(
            "2 ^ 8 = 256",
            heading => 'Calculator',
            html => qq(<div>2<sup>8</sup> = <a href="javascript:;" onClick="document.x.q.value='256';document.x.q.focus();">256</a></div>)
        ),
        '2 *7' => test_zci(
            "2 * 7 = 14",
            heading => 'Calculator',
            html => qq(<div>2 * 7 = <a href="javascript:;" onClick="document.x.q.value='14';document.x.q.focus();">14</a></div>)
        ),
        '1 dozen * 2' => test_zci(
            "1 dozen * 2 = 24",
            heading => 'Calculator',
            html => qq(<div>1 dozen * 2 = <a href="javascript:;" onClick="document.x.q.value='24';document.x.q.focus();">24</a></div>)
        ),
        'dozen + dozen' => test_zci(
            "dozen + dozen = 24",
            heading => 'Calculator',
            html => qq(<div>dozen + dozen = <a href="javascript:;" onClick="document.x.q.value='24';document.x.q.focus();">24</a></div>)
        ),
        '2divided by 4' => test_zci(
            "2 divided by 4 = 0.5",
            heading => 'Calculator',
            html => qq(<div>2 divided by 4 = <a href="javascript:;" onClick="document.x.q.value='0.5';document.x.q.focus();">0.5</a></div>)
        ),
        '(2c) + pi' => test_zci(
            "(2 speed of light) + pi = 599,584,919.141593",
            heading => 'Calculator',
            html => qq(<div>(2 speed of light) + pi = <a href="javascript:;" onClick="document.x.q.value='599,584,919.141593';document.x.q.focus();">599,584,919.141593</a></div>)
        ),
        '2^dozen' => test_zci(
            "2 ^ dozen = 4,096",
            heading => 'Calculator',
            html => qq(<div>2<sup>dozen</sup> = <a href="javascript:;" onClick="document.x.q.value='4,096';document.x.q.focus();">4,096</a></div>)
        ),
        '2^2' => test_zci(
            "2 ^ 2 = 4",
            heading => 'Calculator',
            html => qq(<div>2<sup>2</sup> = <a href="javascript:;" onClick="document.x.q.value='4';document.x.q.focus();">4</a></div>)
        ),
        '2^0.2' => test_zci(
            "2 ^ 0.2 = 1.14869835499704",
            heading => 'Calculator',
            html => qq(<div>2<sup>0.2</sup> = <a href="javascript:;" onClick="document.x.q.value='1.14869835499704';document.x.q.focus();">1.14869835499704</a></div>)
        ),
        'cos(0)' => test_zci(
            "cos(0) = 1",
            heading => 'Calculator',
            html => qq(<div>cos(0) = <a href="javascript:;" onClick="document.x.q.value='1';document.x.q.focus();">1</a></div>)
        ),
        'tan(1)' => test_zci(
            "tan(1) = 1.5574077246549",
            heading => 'Calculator',
            html => qq(<div>tan(1) = <a href="javascript:;" onClick="document.x.q.value='1.5574077246549';document.x.q.focus();">1.5574077246549</a></div>)
        ),
        'sin(1)' => test_zci(
            "sin(1) = 0.841470984807897",
            heading => 'Calculator',
            html => qq(<div>sin(1) = <a href="javascript:;" onClick="document.x.q.value='0.841470984807897';document.x.q.focus();">0.841470984807897</a></div>)
        ),
        '//' => undef,
        dividedbydividedby => undef,
);

done_testing;

