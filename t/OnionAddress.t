#!/usr/bin/env perl

use strict;
use warnings;

use Test::More;
use DDG::Test::Goodie;
use URI::Escape;

zci answer_type => 'onion_address';
zci is_cached   => 1;


ddg_goodie_test(
    [
        'DDG::Goodie::OnionAddress'
    ],

    'https://3g2upl4pq6kufc4m.onion' =>
    test_zci(
        '3g2upl4pq6kufc4m.onion',
        make_structured_answer(
            "3g2upl4pq6kufc4m.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 3g2upl4pq6kufc4m.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    'How to access https://3g2upl4pq6kufc4m.onion?' =>
    test_zci(
        '3g2upl4pq6kufc4m.onion',
        make_structured_answer(
            "3g2upl4pq6kufc4m.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 3g2upl4pq6kufc4m.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    '3g2upl4pq6kufc4m.onion/?q=dont+track+us' =>
    test_zci(
        '3g2upl4pq6kufc4m.onion',
        make_structured_answer(
            "3g2upl4pq6kufc4m.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 3g2upl4pq6kufc4m.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    'How to access https://3g2upl4pq6kufc4m.onion/privacy?' =>
    test_zci(
        '3g2upl4pq6kufc4m.onion',
        make_structured_answer(
            "3g2upl4pq6kufc4m.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 3g2upl4pq6kufc4m.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    'How to access 3g2upl4pq6kufc4m.onion/anti-censorship/?' =>
    test_zci(
        '3g2upl4pq6kufc4m.onion',
        make_structured_answer(
            "3g2upl4pq6kufc4m.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 3g2upl4pq6kufc4m.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    'http://3g2upl4pq6kufc4m.onion.link' =>
    test_zci(
        '3g2upl4pq6kufc4m.onion',
        make_structured_answer(
            "3g2upl4pq6kufc4m.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 3g2upl4pq6kufc4m.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),
    
    'https://0123456789abcdef.onion' =>
    test_zci(
        '0123456789abcdef.onion',
        make_structured_answer(
            "0123456789abcdef.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 0123456789abcdef.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    '0123456789abcdef.onion:123/' =>
    test_zci(
        '0123456789abcdef.onion',
        make_structured_answer(
            "0123456789abcdef.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 0123456789abcdef.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    'https://0123456789abcdef.onion:5000/about-us' =>
    test_zci(
        '0123456789abcdef.onion',
        make_structured_answer(
            "0123456789abcdef.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 0123456789abcdef.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    'http://0000000000000000.onion/' =>
    test_zci(
        '0000000000000000.onion',
        make_structured_answer(
            "0000000000000000.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access 0000000000000000.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    'what is aaaaaaaaaaaaaaaa.onion?' =>
    test_zci(
        'aaaaaaaaaaaaaaaa.onion',
        make_structured_answer(
            "aaaaaaaaaaaaaaaa.onion",
            "Onion/Hidden service",
            "You are trying to reach an onion/hidden service. To access aaaaaaaaaaaaaaaa.onion via web you will have to use the Tor Browser.",
            "https://www.torproject.org/projects/torbrowser.html.en#downloads",
        )
    ),

    'ftp://3g2upl4pq6kufc4m.onion' => undef,
    'ssh://3g2upl4pq6kufc4m.onion' => undef,
    'irc://3g2upl4pq6kufc4m.onion' => undef,

);

sub make_structured_answer {
    my ($onion_name) = @_;

    return structured_answer => {
        id => 'onion_address',
        name => 'OnionAddress',
        data => {
            title => $onion_name,
            subtitle => 'Onion/Hidden service',
            description => 'You are trying to reach an onion/hidden service. To access '.$onion_name.' via web you will have to use the Tor Browser.'
        },
        meta => {
            sourceName => "Tor Project",
            sourceUrl => "https://www.torproject.org/projects/torbrowser.html.en#downloads"
        },
        templates => {
            group => 'text',
            options => {
                moreAt => 1
            }
        }
    };
};

done_testing;
