#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "catalan";
zci is_cached   => 1;

ddg_goodie_test(
    [qw( DDG::Goodie::Catalan )],
    'catalan 30' => test_zci(
        'The 30th catalan number is 3.8149865021e+15.',
        structured_answer => {
        id => 'catalan_number',
        name => 'Answer',
        data => {
            title => "3.8149865021e+15",
            subtitle => "30th Catalan number."
        },
        templates => {
            group => 'text',
        }
        
      }
    ),
    '10th catalan number' => test_zci(
        'The 10th catalan number is 16,796.',
        structured_answer => {
        id => 'catalan_number',
        name => 'Answer',
        data => {
            title => "16,796",
            subtitle => "10th Catalan number."
        },
        templates => {
            group => 'text',
        }
        
      }
    ),
    'Tell a catalan number' => undef,
    'what are catalan numbers?' => undef,
);

done_testing;
