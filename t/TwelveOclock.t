#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "twelve_oclock";
zci is_cached   => 1;

my $noon = '12:00pm is noon';
my $midnight = '12:00am is midnight';
my $correct_midnight = 'Yes, 12:00am is midnight';
my $correct_noon = 'Yes, 12:00pm is noon';
my $wrong_midnight =  'No, 12:00am is midnight';
my $wrong_noon = 'No, 12:00pm is noon';
	
sub build_test {
	my ($text) = @_;
	return test_zci($text, structured_answer => {
		data => {
			title => $text,
			subtitle => 'Midnight or noon'
		},
		templates => {
			group => 'text'
		}
	});
}
	
ddg_goodie_test(
    [qw( DDG::Goodie::TwelveOclock )],
    'is 1200a.m. noon'               => build_test($wrong_midnight),
    'is 1200pm noon?'                => build_test($correct_noon),
    'is 12:00 am midnight'           => build_test($correct_midnight),
    'is 12:00 pm midnight?'          => build_test($wrong_noon),
    'is 12:00 p.m. midnight?'        => build_test($wrong_noon),
    'is 12:00 AM midnight?'          => build_test($correct_midnight),
    'noon is 12:00 p.m.'             => build_test($correct_noon),
    'midnight is 12 AM'              => build_test($correct_midnight),
    'is 12:00P.M. midnight or noon?' => build_test($noon),
    'is 12am noon or midnight'       => build_test($midnight),
    'when is midnight'               => build_test($midnight),
    'when is noon?'                  => build_test($noon),
    'threat level midnight'          => undef,
    '12 midnight'                    => undef,
    'midnight movies'                => undef,
    'when is the midnight showing?'  => undef,
    'when is noon in Jakarta?'       => undef,
);

done_testing;
