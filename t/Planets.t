#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;
use DDG::Test::Location;

zci answer_type => "planets";
zci is_cached   => 1;

  # Test Code # START
  my $test_location = test_location('us'); 
  my $location = $test_location->country_code;
  # Test Code # END

ddg_goodie_test(
    [qw( DDG::Goodie::Planets )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'example query' => test_zci('query'),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'bad example query' => undef,
);

done_testing;
