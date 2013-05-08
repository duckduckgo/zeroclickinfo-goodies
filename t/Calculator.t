#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'calc';
zci is_cached => 1;

ddg_goodie_test(
        [qw( DDG::Goodie::Calculator )],
        'what is 2+2' => test_zci(
            "2 + 2 = 4",
            heading => 'Calculator',
            html => qq(<div>2 + 2 = <a href="javascript:;" onClick="document.x.q.value='4';document.x.q.focus();">4</a></div>)
        ),
        '2+2' => test_zci(
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
);

done_testing;

