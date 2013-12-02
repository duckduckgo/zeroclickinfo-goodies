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
            "(2 speed of light) + pi = 599,584,919.14159265358979323846264338327950288",
            heading => 'Calculator',
            html => qq(<div>(2 speed of light) + pi = <a href="javascript:;" onClick="document.x.q.value='599,584,919.14159265358979323846264338327950288';document.x.q.focus();">599,584,919.14159265358979323846264338327950288</a></div>)
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
            "2 ^ 0.2 = 1.148698354997035006798626946777927589444",
            heading => 'Calculator',
            html => qq(<div>2<sup>0.2</sup> = <a href="javascript:;" onClick="document.x.q.value='1.148698354997035006798626946777927589444';document.x.q.focus();">1.148698354997035006798626946777927589444</a></div>)
        ),
        'cos(0)' => test_zci(
            "cos(0) = 1",
            heading => 'Calculator',
            html => qq(<div>cos(0) = <a href="javascript:;" onClick="document.x.q.value='1';document.x.q.focus();">1</a></div>)
        ),
        'tan(1)' => test_zci(
            "tan(1) = 1.557407724654902230506974807458360173087",
            heading => 'Calculator',
            html => qq(<div>tan(1) = <a href="javascript:;" onClick="document.x.q.value='1.557407724654902230506974807458360173087';document.x.q.focus();">1.557407724654902230506974807458360173087</a></div>)
        ),
        'sin(1)' => test_zci(
            "sin(1) = 0.8414709848078965066525023216302989996226",
            heading => 'Calculator',
            html => qq(<div>sin(1) = <a href="javascript:;" onClick="document.x.q.value='0.8414709848078965066525023216302989996226';document.x.q.focus();">0.8414709848078965066525023216302989996226</a></div>)
        ),
        '//' => undef,
        dividedbydividedby => undef,
        '18^23%77' => test_zci(
            "18 ^ 23 % 77 = 2",
            heading => 'Calculator',
            html => qq(<div>18<sup>23 % 77</sup> = <a href="javascript:;" onClick="document.x.q.value='2';document.x.q.focus();">2</a></div>),
        ),
);

done_testing;

