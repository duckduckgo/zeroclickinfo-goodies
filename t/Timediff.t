#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;
zci answer_type => 'timediff';
zci is_cached   => 0;

sub make_answer(%){
    my ($input) = @_;
    
    return {
        data => {
            days    => $input->{'days'},
            hours   => $input->{'hours'},
            minutes => $input->{'minutes'},
            seconds => $input->{'seconds'},
        },
        templates => {
            group => 'text',
            options => {
                content => 'DDH.timediff.content'
            }
        }
    };
}

ddg_goodie_test(
    ['DDG::Goodie::Timediff'],

    'timediff 2016-04-11T09:00:00 2016-04-08T18:17:00' => test_zci(
        "225780 seconds",
        structured_answer => make_answer({
			seconds => 225780,
			minutes => 3763,
			hours => 62.7166666666667,
			days => 2.61319444444444,
        })
    ),
    'timediff 2016-04-08T20:00:00 2016-04-10T21:00:00' => test_zci(
        "176400 seconds",
        structured_answer => make_answer({
			seconds => 176400,
			minutes => 2940,
			hours => 49,
			days => 2.04166666666667,
        })
    ),
	
	'timediff examples' => undef,
	'timediff function' => undef,
);
done_testing;
