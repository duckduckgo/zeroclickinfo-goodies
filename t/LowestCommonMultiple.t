#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "lowest_common_multiple";
zci is_cached   => 1;
#!/usr/bin/env perl
ddg_goodie_test(

    [qw( DDG::Goodie::LowestCommonMultiple )],

    'lcm 9 81' => test_zci(

        'Lowest Common Multiple of 9 and 81 is 81.',

        structured_answer => {

            input     => ['9 and 81'],

            operation => 'Lowest Common Multiple',

            result    => 81

        }

    ),

    'lcm 9 10' => test_zci(

        'Lowest Common Multiple of 9 and 10 is 90.',

        structured_answer => {

            input     => ['9 and 10'],

            operation => 'Lowest Common Multiple',

            result    => 90

        }

    ),

'lcm 11 2' => test_zci(

        'Lowest Common Multiple of 11 and 2 is 22.',

        structured_answer => {

            input     => ['11 and 2'],

            operation => 'Lowest Common Multiple',

            result    => 22

        }

    ),

    # Etc...

);



done_testing;
