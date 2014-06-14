#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use utf8;

zci answer_type => 'plural';
zci is_cached => 1;

ddg_goodie_test(
  [qw(
    DDG::Goodie::Plural
  )],

  #Primary example
  'pluralise starfish' => test_zci(qr/starfish(es)?/, html => qr/starfish(es)?/),

  #Secondary examples
  'pluralize fungus' => test_zci(qr/fung(i|uses)/, html => qr/fung(i|uses)/),
  'what is the plural form of cul-de-sac' => test_zci(qr/culs?-de-sacs?/, html => qr/culs?-de-sacs?/),
  'how do you pluralise radius' => test_zci(qr/radi(i|uses)/, html => qr/radi(i|uses)/),
  'what is the correct pluralization of medium' => test_zci(qr/medi(a|ums)/, html => qr/medi(a|ums)/),
  'pluralise the word plethora' => test_zci('plethoras', html => qr/plethoras/),
  'plural inflection of bacterium' => test_zci('bacteria', html => qr/bacteria/),

  #British/American spellings
  'what is the plural of colour' => test_zci('colours', html => qr/colours/),
  'how to pluralize color' => test_zci('colors', html => qr/colors/),
  'what is the correct plural of story' => test_zci('stories', html => qr/stories/),
  'storey plural' => test_zci('storeys', html => qr/storeys/),

  #Non-ASCII characters
  'what is the plural of café' => test_zci('cafés', html => qr/cafés/),
  'pluralize œsophagus' => test_zci('œsophagi', html => qr/œsophagi/),

  #I LIKE CAPS LOCK
  'What Is The Plural Of Octopus' => test_zci(qr/octop(i|odes|uses)/, html => qr/octop(i|odes|uses)/),
  'PLURAL OF SHOUT' => test_zci('shouts', html => qr/shouts/),

  #Should not trigger
  'wikipedia plural' => undef,
  'list of english words with irregular plural forms' => undef,
  'i love talking about pluralizing things' => undef,
  'the plural juror' => undef,
  'what is the plural of thisisamadeupword' => undef,
  'pluralise this long list of words' => undef,
);

done_testing;
