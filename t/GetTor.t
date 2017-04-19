#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'get_tor';
zci is_cached => 1;

ddg_goodie_test(
    [
        'DDG::Goodie::GetTor'
    ],
    'gettor' =>
        test_zci(
            'torbrowser',
            html => "<div class='zci__caption'>Send a blank email to <strong>gettor\@torproject.org</strong> and you will receive instructions to download Tor Browser from popular cloud services.</div>"
        ),
    'get tor' =>
        test_zci(
            'torbrowser',
            html => "<div class='zci__caption'>Send a blank email to <strong>gettor\@torproject.org</strong> and you will receive instructions to download Tor Browser from popular cloud services.</div>"
        ),
    'get torbrowser' =>
        test_zci(
            'torbrowser',
            html => "<div class='zci__caption'>Send a blank email to <strong>gettor\@torproject.org</strong> and you will receive instructions to download Tor Browser from popular cloud services.</div>"
        ),
    'get torbrowser' =>
        test_zci(
            'torbrowser',
            html => "<div class='zci__caption'>Send a blank email to <strong>gettor\@torproject.org</strong> and you will receive instructions to download Tor Browser from popular cloud services.</div>"
        ),
    'torbrowser' =>
        test_zci(
            'torbrowser',
            html => "<div class='zci__caption'>Send a blank email to <strong>gettor\@torproject.org</strong> and you will receive instructions to download Tor Browser from popular cloud services.</div>"
        ),
    'Tor Browser' =>
        test_zci(
            'torbrowser',
            html => "<div class='zci__caption'>Send a blank email to <strong>gettor\@torproject.org</strong> and you will receive instructions to download Tor Browser from popular cloud services.</div>"
        ),
    'gettor bridges' =>
        test_zci(
            'bridges',
            html => "<div class='zci__caption'>Send a blank email to* <strong>bridges\@torproject.org</strong> and you will receive instructions on how to get some bridges.</div><em>*From Riseup, Gmail, or Yahoo accounts only.</em>"
        ),
    'get tor bridges' =>
        test_zci(
            'bridges',
            html => "<div class='zci__caption'>Send a blank email to* <strong>bridges\@torproject.org</strong> and you will receive instructions on how to get some bridges.</div><em>*From Riseup, Gmail, or Yahoo accounts only.</em>"
        ),
    'get bridges' =>
        test_zci(
            'bridges',
            html => "<div class='zci__caption'>Send a blank email to* <strong>bridges\@torproject.org</strong> and you will receive instructions on how to get some bridges.</div><em>*From Riseup, Gmail, or Yahoo accounts only.</em>"
        ),
    'gettor browser bridges' =>
        test_zci(
            'bridges',
            html => "<div class='zci__caption'>Send a blank email to* <strong>bridges\@torproject.org</strong> and you will receive instructions on how to get some bridges.</div><em>*From Riseup, Gmail, or Yahoo accounts only.</em>"
        ),
    'get torbrowser bridges' =>
        test_zci(
            'bridges',
            html => "<div class='zci__caption'>Send a blank email to* <strong>bridges\@torproject.org</strong> and you will receive instructions on how to get some bridges.</div><em>*From Riseup, Gmail, or Yahoo accounts only.</em>"
        ),
    'get tor browser bridges' =>
        test_zci(
            'bridges',
            html => "<div class='zci__caption'>Send a blank email to* <strong>bridges\@torproject.org</strong> and you will receive instructions on how to get some bridges.</div><em>*From Riseup, Gmail, or Yahoo accounts only.</em>"
        ),
    'tor bridges' =>
        test_zci(
            'bridges',
            html => "<div class='zci__caption'>Send a blank email to* <strong>bridges\@torproject.org</strong> and you will receive instructions on how to get some bridges.</div><em>*From Riseup, Gmail, or Yahoo accounts only.</em>"
        ),
);

done_testing;