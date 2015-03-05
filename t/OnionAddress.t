#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'onion_address';
zci is_cached => 1;

ddg_goodie_test(
    [
        'DDG::Goodie::OnionAddress'
    ],
    'https://3g2upl4pq6kufc4m.onion' =>
        test_zci(
            '3g2upl4pq6kufc4m',
            heading => 'Access to onion service',
            html => "Access 3g2upl4pq6kufc4m.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://3g2upl4pq6kufc4m.tor2web.org'>Tor2web</a>."
        ),
    'How to access https://3g2upl4pq6kufc4m.onion?' =>
        test_zci(
            '3g2upl4pq6kufc4m',
            heading => 'Access to onion service',
            html => "Access 3g2upl4pq6kufc4m.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://3g2upl4pq6kufc4m.tor2web.org'>Tor2web</a>."
        ),
    'How to access https://3g2upl4pq6kufc4m.onion/?q=dont+track+us' =>
        test_zci(
            '3g2upl4pq6kufc4m',
            heading => 'Access to onion service',
            html => "Access 3g2upl4pq6kufc4m.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://3g2upl4pq6kufc4m.tor2web.org'>Tor2web</a>."
        ),
    'How to access https://3g2upl4pq6kufc4m.onion/privacy?' =>
        test_zci(
            '3g2upl4pq6kufc4m',
            heading => 'Access to onion service',
            html => "Access 3g2upl4pq6kufc4m.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://3g2upl4pq6kufc4m.tor2web.org'>Tor2web</a>."
        ),
    'How to access https://3g2upl4pq6kufc4m.onion/anti-censorship/?' =>
        test_zci(
            '3g2upl4pq6kufc4m',
            heading => 'Access to onion service',
            html => "Access 3g2upl4pq6kufc4m.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://3g2upl4pq6kufc4m.tor2web.org'>Tor2web</a>."
        ),
    'http://3g2upl4pq6kufc4m.onion' =>
        test_zci(
            '3g2upl4pq6kufc4m',
            heading => 'Access to onion service',
            html => "Access 3g2upl4pq6kufc4m.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://3g2upl4pq6kufc4m.tor2web.org'>Tor2web</a>."
        ),
    'https://0123456789abcdef.onion/' =>
        test_zci(
            '0123456789abcdef',
            heading => 'Access to onion service',
            html => "Access 0123456789abcdef.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://0123456789abcdef.tor2web.org'>Tor2web</a>."
        ),
    'https://0123456789abcdef.onion:123/' =>
        test_zci(
            '0123456789abcdef',
            heading => 'Access to onion service',
            html => "Access 0123456789abcdef.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://0123456789abcdef.tor2web.org'>Tor2web</a>."
        ),
    'https://0123456789abcdef.onion:5000/about-us' =>
        test_zci(
            '0123456789abcdef',
            heading => 'Access to onion service',
            html => "Access 0123456789abcdef.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://0123456789abcdef.tor2web.org'>Tor2web</a>."
        ),
    'http://0000000000000000.onion/' =>
        test_zci(
            '0000000000000000',
            heading => 'Access to onion service',
            html => "Access 0000000000000000.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://0000000000000000.tor2web.org'>Tor2web</a>."
        ),
    'what is https://aaaaaaaaaaaaaaaa.onion?' =>
        test_zci(
            'aaaaaaaaaaaaaaaa',
            heading => 'Access to onion service',
            html => "Access aaaaaaaaaaaaaaaa.onion using the <a href='https://www.torproject.org/projects/torbrowser.html.en'>Tor Browser</a> or via <a href='https://aaaaaaaaaaaaaaaa.tor2web.org'>Tor2web</a>."
        ),
);

done_testing;