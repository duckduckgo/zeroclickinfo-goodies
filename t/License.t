#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'license';
zci is_cached  => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::License )],
    'mozilla license' => test_zci(html => '<code>This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.</code>'),
    'abc license' => undef
);

done_testing;