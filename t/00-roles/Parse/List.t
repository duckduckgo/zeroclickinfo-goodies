#!/usr/bin/env perl

use strict;
use warnings;

use Test::Most;

subtest initialization => sub {
    { package ListTester; use Moo; with 'DDG::GoodieRole::Parse::List'; 1; }

    new_ok('ListTester', [], 'Applied to a class');
};

done_testing;

1;
