#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'time_conversion';
zci is_cached   => 0;

my @zero  = (re(qr/Thu Jan 01 00:00:00 1970 UTC/), 
    structured_answer => {
        data => {
            record_data => {                                                                                                                                 
                    'Time (America/New_York)' => "Wed Dec 31 19:00:00 1969 EST",                                                                                 
                    'Time (UTC)' => "Thu Jan 01 00:00:00 1970 UTC",                                                                                 
                    'Unix Epoch' => '0000000000000'                                                                                                      
                }, 
            record_keys => ["Unix Epoch", "Time (UTC)", "Time (America/New_York)"],
        },
        templates => {
            group => 'list',
            options => {
                content => 'record'
            }
        }
    }
);
my @zeroi  = (re(qr/Thu Jan 01 00:00:00 1970 UTC/), 
    structured_answer => {
        data => {
            record_data => {                                                                                                                                 
                    'Time (America/New_York)' => "Wed Dec 31 19:00:00 1969 EST",                                                                                 
                    'Time (UTC)' => "Thu Jan 01 00:00:00 1970 UTC",                                                                                 
                    'Unix Epoch' => 0                                                                                                     
                }, 
            record_keys => ["Unix Epoch", "Time (UTC)", "Time (America/New_York)"],
        },
        templates => {
            group => 'list',
            options => {
                content => 'record'
            }
        }
    }
);

my @now   = (re(qr/Unix Epoch./),              
    structured_answer => {
        data => ignore(),
        templates => {
            group => 'list',
            options => {
                content => 'record'
            }
        }
    }
);
my @then  = (re(qr/Tue Nov 18 00:28:30 1930 UTC/), 
    structured_answer => {
        data => ignore(),
        templates => {
            group => 'list',
            options => {
                content => 'record'
            }
        }
    }
);
my @later = (re(qr/Tue Jan 19 03:14:07 2038 UTC/), 
    structured_answer => {
        data => ignore(),
        templates => {
            group => 'list',
            options => {
                content => 'record'
            }
        }
    }
);

ddg_goodie_test([qw(
          DDG::Goodie::UnixTime
          )
    ],
    'unix time 0000000000000' 	 => test_zci(@zero),
    'epoch 0'                 	 => test_zci(@zeroi),
    'utc time 0'              	 => test_zci(@zeroi),
    'epoch 2147483647'        	 => test_zci(@later),
    '2147483647 epoch'        	 => test_zci(@later),
    'timestamp 2147483647'    	 => test_zci(@later),
    'utc time 2147483647'     	 => test_zci(@later),
    'epoch converter 2147483647' => test_zci(@later),
    'datetime'                	 => test_zci(@now),
    'unix time'               	 => test_zci(@now),
    'unix epoch'              	 => test_zci(@now),
    'utc time'                	 => test_zci(@now),
    'utc now'                 	 => test_zci(@now),
    'current utc'             	 => test_zci(@now),
    'time since epoch'        	 => test_zci(@now),
    'epoch -1234567890'       	 => test_zci(@then),
    '-1234567890 epoch'       	 => test_zci(@then),
    'timestamp -1234567890'   	 => test_zci(@then),
    'utc time -1234567890'    	 => test_zci(@then),
    'timestamp'               	 => undef,
    'time'                    	 => undef,
    'epoch'                   	 => undef,
    'unix time info'          	 => undef,
);

done_testing;
