#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'guid';
zci is_cached => 0;

my $heading = 'Random GUID';

ddg_goodie_test(
  	[qw(
  		DDG::Goodie::GUID
  	)],

	# Check that the trigger kicks in.
  	'guid' => test_zci(qr/^([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}$/,
  		html => qr/./,
  		heading => $heading
  	),
	'uuid' => test_zci(qr/^([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}$/,
  		html => qr/./,
  		heading => $heading
  	),
  	'globally unique identifier' => test_zci(qr/^([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}$/,
  		html => qr/./,
  		heading => $heading
  	),
  	'rfc 4122' => test_zci(qr/^([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}$/,
  		html => qr/./,
  		heading => $heading
  	),

  	# Check the HTML. Just once.
  	'guid' => test_zci(qr/^([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}$/,
  		html => qr/^<input type="text" onclick='this.select\(\);' size="36" value="([a-zA-Z]|\d){8}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){4}-([a-zA-Z]|\d){12}"\/>$/,
  		heading => $heading
  	),
);

done_testing;
