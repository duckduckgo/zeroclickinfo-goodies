#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

use JSON::MaybeXS;

zci answer_type => 'html_entities';
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my @test_params = @_;

    open(my $fh, "<", "share/goodie/htmlentities/entities.json") or return;

    my $json = do { local $/;  <$fh> };
    my $table = decode_json($json) or return;

    return 'HTML Entities',
        structured_answer => {

            data => {
                title => "HTML Entities",
                table => $table
            },

            meta => {
                sourceName => "W3.org",
                sourceUrl => "https://dev.w3.org/html5/html-author/charref"
            },

            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.htmlentities.content',
                    moreAt => 1
                }
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::HTMLEntities )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries
    'html entities' => build_test(),
    'html entities table' => build_test(),
    'html entities list' => build_test(),
    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'bad example query' => undef,
);

done_testing;
