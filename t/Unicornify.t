#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use Unicornify::URL;


zci answer_type => 'unicornify';
zci is_cached => 1;
ddg_goodie_test(
	[qw(
		DDG::Goodie::Unicornify
		)],
	'unicornify example@example.com' =>
        test_zci('This is a unique unicorn for example@example.com',
        structured_answer => {
            data => {
                subtitle => "Unique unicorn",
                title => 'example@example.com',
                url => unicornify_url(email => 'example@example.com', size => "200"),
                image => unicornify_url(email => 'example@example.com', size => "100")
            },
            meta => {
                sourceName => "Unicornify",
                sourceUrl => 'http://unicornify.appspot.com/' 
            }, 
            templates => {
                group => "icon",
                item => 0,
                moreAt => 1,
                variants => {
                    iconTitle => 'large',
                    iconImage => 'large'
                }
            }
        }));

done_testing;
