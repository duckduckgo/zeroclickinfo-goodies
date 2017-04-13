#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use YAML::XS 'LoadFile';

zci answer_type => 'url_escape_codes';
zci is_cached   => 1;

my $url_escape_codes = LoadFile('share/goodie/url_escape_codes/data.yml');

sub build_structured_answer {
    my $result = {
        title => 'URL Escape Codes',
        table => $url_escape_codes
    };

    # Check if type of header data is an Array
    isa_ok($result->{table}->{header}, 'ARRAY');

    # Check if type of body data is an Array
    isa_ok($result->{table}->{body}, 'ARRAY');

    # Check if each Header Hash has required keys
    for (my $i = 0; $i < $#{$result->{table}->{header}}; $i++) {
      cmp_deeply(
            $result->{table}->{header}->[$i],
            {
                key => ignore(),
                abbr => ignore()
            }
        );
    }

    # Check if each Body Hash has required keys
    for (my $i = 0; $i < $#{$result->{table}->{body}}; $i++) {
      cmp_deeply(
            $result->{table}->{body}->[$i],
            {
                Char => ignore(),
                'Esc Code' => ignore()
            }
        );
    }

    # Check if title is correct or not
    is($result->{title}, 'URL Escape Codes');

    return '',
        structured_answer => {
            id => 'url_escape_codes',
            name => 'URL Escape Codes',
            data => {
                title => 'URL Escape Codes',
                table => $url_escape_codes
            },
            meta => {
                sourceName => 'december.com',
                sourceUrl => 'http://www.december.com/html/spec/esccodes.html'
            },
            templates => {
                group => 'list',
                item => 0,
                options => {
                    content => 'DDH.url_escape_codes.content',
                    moreAt => 1
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::UrlEscapeCodes )],
    'url escape' => build_test(),
    'url escaping' => build_test(),
    'url escape codes' => build_test(),
    'url escape characters' => build_test(),
    'url escape sequences' => build_test(),
    'url encoder' => undef,
    'url decoder' => undef,
    'convert url escape' => undef,
    'dont run for this' => undef
);

done_testing;
