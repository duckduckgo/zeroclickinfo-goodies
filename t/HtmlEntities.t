#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use YAML::XS 'LoadFile';

zci answer_type => 'html_entities';
zci is_cached   => 1;

my $table = LoadFile('share/goodie/html_entities/entities.yml');

sub build_structured_answer {
    my @test_params = @_;

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
                    content => 'DDH.html_entities.content',
                    chompContent => 1,
                    moreAt => 1
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::HtmlEntities )],
    'html entities' => build_test(),
    'html entities table' => build_test(),
    'html entities list' => build_test(),
    'html named entities' => build_test(),
    'list of html entities' => build_test(),
    'html' => undef,
    'html entity' => undef,
    'html alphanumeric characters' => undef
);

done_testing;
