#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "firefoxos";
zci is_cached   => 1;

#Structured answer template data
my $templateData = {
            data => ignore(),
            meta => {
                sourceName => "Mozilla Developer Network",
                sourceUrl => "https://developer.mozilla.org/en-US/Apps/Reference/Firefox_OS_device_APIs" 
            },
            templates => {
                group => "info",       
                options => {
                    moreAt => 1
                }
            }
        };

ddg_goodie_test(
    [qw( DDG::Goodie::FirefoxOS)],

    # Unit type - imperial
    "firefoxos alarm api" => test_zci("alarms", structured_answer => $templateData),
    "fxos api contacts" => test_zci("contacts", structured_answer => $templateData),
    'Firefox OS push API' => test_zci("push",  structured_answer => $templateData),

    # Do not trigger

    'fxos alarm' => undef,
    'firefox alarm api' => undef,
    'firefoxos alarm app' => undef,
    'firefox os api' => undef
);

done_testing;
