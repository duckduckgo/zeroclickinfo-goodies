#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Test::MockTime qw( :all );

zci answer_type => 'days_between';
zci is_cached   => 0;

ddg_goodie_test(
    [qw( DDG::Goodie::DaysBetween)],
);

restore_time();
done_testing;
