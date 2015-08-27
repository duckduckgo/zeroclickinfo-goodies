#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "HttpError";
zci is_cached   => 1;

ddg_goodie_test(
    [qw(
        DDG::Goodie::http_error
    )],
    'http error 409' => test_zci('The server took too long to display the webpage or there were too many people requesting the same page. Try again later..'),
    'http error 123' => undef,
);
done_testing;
