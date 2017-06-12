#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;
use YAML::XS 'LoadFile';

zci answer_type => 'ascii_table';
zci is_cached   => 1;

my $ascii = LoadFile('share/goodie/ascii_table/data.yml');

sub build_structured_answer {

    my $result = {
        title => 'ASCII Table',
        table => $ascii
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
                Dec => ignore(),
                Hex => ignore(),
                Oct => ignore(),
                Html => ignore(),
                Char => ignore()
            }
        );
    }

    # Check if title is correct or not
    is($result->{title}, 'ASCII Table');

    return '',
        structured_answer => {
            id => 'ascii_table',
            name => 'ASCII Table',
            data => $result,
            meta => {
                sourceName => 'asciitable.com',
                sourceUrl => 'http://www.asciitable.com/'
            },
            templates => {
                group => 'list',
                item => 0,
                options => {
                    content => 'DDH.ascii_table.content',
                    moreAt => 1
                }
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::AsciiTable )],
    'ascii table' => build_test(),
    'ascii reference table' => build_test(),
    'ascii reference' => build_test(),
    'ascii characters' => build_test(),
    'character codes' => build_test(),
    'ascii character map' => build_test(),
    'list of ascii characters' => build_test(),
    'list of ascii codes' => build_test(),
    'list of char codes' => build_test(),
    'list of vegetables' => undef,
    'list of ascii' => undef,
    'ascii convertor' => undef,
    'ascii conversion' => undef,
    'convert ascii' => undef,
    'dont run for this' => undef
);

done_testing;
