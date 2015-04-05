#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => "is_it_christmas";
zci is_cached   => 1;

#Test using non-christmas date, result will be no if triggered
set_fixed_time("2014-06-11T09:45:56");
ddg_goodie_test(
    [qw( DDG::Goodie::IsItChristmas )],
    'is it xmas' => test_zci('No'),
    'is it christmas' => test_zci('No'),
    'christmas' => undef,
);

#Test using christmas of 2014 as the date, result will be yes if triggered
set_fixed_time("2014-12-25T09:45:56");
ddg_goodie_test(
    [qw( DDG::Goodie::IsItChristmas )],
    'is it xmas' => test_zci('Yes'),
    'is it christmas' => test_zci('Yes'),
    'christmas' => undef,
);

restore_time();
done_testing;