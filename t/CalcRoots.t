#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'root';
zci is_cached => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::CalcRoots
    )],
    '2nd root of 100' => test_zci("The 2-root of 100 is 10 (10 times the 2-root of 1).", html => qq(<sup>2</sup>&radic;100 =  <a href="javascript:;" onclick="document.x.q.value='10';document.x.q.focus();">10</a> (10&sdot;<sup>2</sup>&radic;1))),
    'cube root of 33' => test_zci("The 3-root of 33 is 3.20753432999583.", html => qq(<sup>3</sup>&radic;33 = <a href="javascript:;" onclick="document.x.q.value='3.20753432999583';document.x.q.focus();">3.20753432999583</a>))
);
done_testing;
