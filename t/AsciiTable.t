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
        table_rows => $ascii
    };
    
    # Check if type of data is an Array
    isa_ok($result->{table_rows}, 'ARRAY');
    
    # Check if each Hash as required keys 
    for (my $i = 0; $i < $#{$result->{table_rows}}; $i++) {
      cmp_deeply(
            $result->{table_rows}->[$i],
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
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.ascii_table.content'   
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
    'ascii convertor' => undef,
    'ascii conversion' => undef,
    'convert ascii' => undef,
    'dont run for this' => undef
);

done_testing;
