#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "military_rank";
zci is_cached   => 1;

# Build a structured answer that should match the response from the
# Perl file.
# sub build_structured_answer {
#     my @test_params = @_;

#     return "plain text response",
#         structured_answer => {

#             data => {
#                 title    => "My Instant Answer Title",
#                 subtitle => "My Subtitle",
#                 # image => "http://website.com/image.png",
#             },

#             templates => {
#                 group => "text",
#                 # options => {
#                 #
#                 # }
#             }
#         };
# }

# Use this to build expected results for your tests.
# sub build_test { test_zci(build_structured_answer(@_)) }

# ddg_goodie_test(
#     [qw( DDG::Goodie::MilitaryRank )],
#     # At a minimum, be sure to include tests for all:
#     # - primary_example_queries
#     # - secondary_example_queries
#     'us army rank' => build_test('query'),
#     # Try to include some examples of queries on which it might
#     # appear that your answer will trigger, but does not.
#     'bad example query' => undef,
# );

ddg_goodie_test(
    [qw( DDG::Goodie::MilitaryRank )],
    # At a minimum, be sure to include tests for all:
    # - primary_example_queries
    # - secondary_example_queries

    'us army rank' => test_zci(
        'United States Army Rank',
        structured_answer => {
            templates => {
                group => 'icon',
            },
            data => [
                {
                    image => '',
                    title => 'Private',
                    subtitle => 'PV1',
                    altSubtitle => 'E-1 | OR-1',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-02.svg',
                    title => 'Private',
                    subtitle => 'PV2',
                    altSubtitle => 'E-2 | OR-2',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-03.svg',
                    title => 'Private First Class',
                    subtitle => 'PFC',
                    altSubtitle => 'E-3 | OR-3',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-04b.svg',
                    title => 'Specialist',
                    subtitle => 'SPC',
                    altSubtitle => 'E-4 | OR-4',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-04a.svg',
                    title => 'Corporal',
                    subtitle => 'CPL',
                    altSubtitle => 'E-4 | OR-4',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-05.svg',
                    title => 'Sergeant',
                    subtitle => 'SGT',
                    altSubtitle => 'E-5 | OR-5',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-06.svg',
                    title => 'Staff Sergeant',
                    subtitle => 'SSG',
                    altSubtitle => 'E-6 | OR-6',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-07.svg',
                    title => 'Sergeant First Class',
                    subtitle => 'SFC',
                    altSubtitle => 'E-7 | OR-7',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-08b.svg',
                    title => 'Master Sergeant',
                    subtitle => 'MSG',
                    altSubtitle => 'E-8 | OR-8',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-08a.svg',
                    title => 'First Sergeant',
                    subtitle => '1SG',
                    altSubtitle => 'E-8 | OR-8',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-09c.svg',
                    title => 'Sergeant Major',
                    subtitle => 'SGM',
                    altSubtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-09b.svg',
                    title => 'Command Sergeant Major',
                    subtitle => 'CSM',
                    altSubtitle => 'E-9 | OR-9',

                },
                {
                    image => 'https://en.wikipedia.org/wiki/File:Army-USA-OR-09a.svg',
                    title => 'Sergeant Major of the Army',
                    subtitle => 'SMA',
                    altSubtitle => 'E-9 | OR-9',

                },
            ],
        },
    ),

    # Try to include some examples of queries on which it might
    # appear that your answer will trigger, but does not.
    'bad example query' => undef,
);

done_testing;
