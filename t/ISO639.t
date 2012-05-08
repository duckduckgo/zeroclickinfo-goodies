#!/usr/bin/env perl
use utf8;
use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci is_cached => 1;

ddg_goodie_test(
  ["DDG::Goodie::ISO639"],
  "iso639 ab" => test_zci(
    qq(Abkhazian (ISO 639-1 ab)),
    html        => qq(Abkhazian (<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639-1 ab</a>)),
    answer_type => "language"
  ),
  "iso639 english" => test_zci(
    qq(English (ISO 639-1 en)),
    html        => qq(English (<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639-1 en</a>)),
    answer_type => "language"
  ),
  "iso-639 en" => test_zci(
    qq(English (ISO 639-1 en)),
    html        => qq(English (<a href="https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes">ISO 639-1 en</a>)),
    answer_type => "language"
  ),
  "iso639 xyz" => undef,
);

done_testing;
