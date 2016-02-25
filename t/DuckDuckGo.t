#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'duckduckgo';
zci is_cached   => 1;

my $id = 'duck_duck_go';

# The results should be static, so these facilitate easier testing of triggers.
my @about_result = (
    'Want to know more about us? https://duckduckgo.com/about',
    structured_answer => {
        id => $id,
        data => {
            title => 'Want to know more about us?',
            subtitle_image => undef,
            subtitle_text => 'Visit our About page',
            subtitle_url => 'https://duckduckgo.com/about'
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.duck_duck_go.subtitle_content'
            }
        }
    });
my @blog_result = (
    'Want to stay up to date with DuckDuckGo? https://duck.co/blog',
    structured_answer => {
        id => $id,
        data => {
            title => 'Want to stay up to date with DuckDuckGo?',
            subtitle_image => undef,
            subtitle_text => 'Visit the official DuckDuckGo blog',
            subtitle_url => 'https://duck.co/blog'
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.duck_duck_go.subtitle_content'
            }
        }
    });
my @help_result = (
    'Need some help? https://duck.co/help',
    structured_answer => {
        id => $id,
        data => {
            title => 'Need some help?',
            subtitle_image => undef,
            subtitle_text => 'Visit our help page',
            subtitle_url => 'https://duck.co/help'
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.duck_duck_go.subtitle_content'
            }
        }
    });
my @irc_result = (
    'Want to chat with us on IRC? http://webchat.freenode.net/?channels=duckduckgo',
    structured_answer => {
        id => $id,
        data => {
            title => 'Want to chat with us on IRC?',
            subtitle_image => undef,
            subtitle_text => 'Visit #duckduckgo on irc.freenode.net',
            subtitle_url => 'http://webchat.freenode.net/?channels=duckduckgo'
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.duck_duck_go.subtitle_content'
            }
        }
    });
my @merch_result = (
    'Looking for DuckDuckGo gear? (Thanks for the support!) https://duck.co/help/community/swag',
    structured_answer => {
        id => $id,
        data => {
            title => 'Looking for DuckDuckGo gear? (Thanks for the support!)',
            subtitle_image => undef,
            subtitle_text => 'Check out the DuckDuckGo store for t-shirts, stickers, and other items',
            subtitle_url => 'https://duck.co/help/community/swag'
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.duck_duck_go.subtitle_content'
            }
        }
    });
my @tor_result = (
    'DuckDuckGo is available on Tor http://3g2upl4pq6kufc4m.onion.link',
    structured_answer => {
        id => $id,
        data => {
            title => 'DuckDuckGo is available on Tor',
            subtitle_image => undef,
            subtitle_text => 'Visit our onion address',
            subtitle_url => 'http://3g2upl4pq6kufc4m.onion.link'
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.duck_duck_go.subtitle_content'
            }
        }
    });
my @shorturl_result = (
    'Need a quicker way to visit DuckDuckGo? http://ddg.gg',
    structured_answer => {
        id => $id,
        data => {
            title => 'Need a quicker way to visit DuckDuckGo?',
            subtitle_image => undef,
            subtitle_text => 'You can also find us at http://ddg.gg',
            subtitle_url => 'http://ddg.gg'
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.duck_duck_go.subtitle_content'
            }
        }
    });
my @zci_result = (
    'Zero Click Info is another term for our Instant Answers that show above the search results http://duckduckhack.com',
    structured_answer => {
        id => $id,
        data => {
            title => 'Zero Click Info is another term for our Instant Answers that show above the search results',
            subtitle_image => undef,
            subtitle_text => 'Learn more about Instant Answers',
            subtitle_url => 'http://duckduckhack.com'
        },
        templates => {
            group => 'text',
            options => {
                subtitle_content => 'DDH.duck_duck_go.subtitle_content'
            }
        }
    });

ddg_goodie_test(
    [qw( DDG::Goodie::DuckDuckGo )],
    # Primary example queries
    'duckduckgo help' => test_zci(@help_result),
    # Secondary example queries
    "ddg tor"                    => test_zci(@tor_result),
    'short URL for duck duck go' => test_zci(@shorturl_result),
    # Other queries
    'duckduckgo Zero-Click Info'            => test_zci(@zci_result),
    'ddg zeroclick'                         => test_zci(@zci_result),
    'duckduckgo about'                      => test_zci(@about_result),
    'ddg merch'                             => test_zci(@merch_result),
    'duckduckgo irc'                        => test_zci(@irc_result),
    "duckduckgo's about"                    => test_zci(@about_result),
    'duck duck go merchandise'              => test_zci(@merch_result),
    "ddgs irc"                              => test_zci(@irc_result),
    "the duckduckgo blog"                   => test_zci(@blog_result),
    'the short url of duck duck go'         => test_zci(@shorturl_result),
    'about duckduck go'                     => test_zci(@about_result),
    'duck duckgos help'                     => test_zci(@help_result),
    "where is the ddg irc"                  => test_zci(@irc_result),
    'what is the short url for duckduckgo?' => test_zci(@shorturl_result),
    'ddg on onion'                          => test_zci(@tor_result),
    'tor on duck duck go'                   => test_zci(@tor_result),
    'duckduckgo onion service'              => test_zci(@tor_result),
    "ddg in tor"                            => test_zci(@tor_result),
    'duckduckgo t-shirt'                    => test_zci(@merch_result),
    'ddg t shirts'                          => test_zci(@merch_result),
    'duck duck go tee'                      => test_zci(@merch_result),
    # Intentionally ignored queries
    irc => undef,
);

done_testing;

