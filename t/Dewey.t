#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'dewey_decimal';
zci is_cached => 1;

sub build_structured_answer
{
    my ($data) = @_;
    return $data, structured_answer => {
        id => "dewey_decimal",
        name => "Answer",
        templates => {
            group => 'list',
            options => {
                content => 'record',
                moreAt => 0
            }
        },
        data => {
            title => "Dewey Decimal System",
            record_data => $data
        }
    };
}

ddg_goodie_test(
    [qw(
        DDG::Goodie::Dewey
    )],
    "dewey 123" => test_zci(build_structured_answer({
        "123" => "Determinism and indeterminism"
    })),
    '646 dewey decimal system' => test_zci(build_structured_answer({
        "646" => "Sewing, clothing, personal living"
    })),
    'dewey decimal system 640s' => test_zci(build_structured_answer({
        "641" => "Food & drink",
        "642" => "Meals & table service",
        "643" => "Housing & household equipment",
        "644" => "Household utilities",
        "645" => "Household furnishings",
        "646" => "Sewing, clothing, personal living",
        "647" => "Management of public households",
        "648" => "Housekeeping",
        "649" => "Child rearing & home care of sick"
    })),
    '#1 in the dewey decimal system' => test_zci(build_structured_answer({
        "001" => "Knowledge"
    })),    
    'dewey decimal system naturalism' => test_zci(build_structured_answer({
        "146" => "Naturalism and related systems"
    })),
    'etymology in the dewey decimal system' => test_zci(build_structured_answer({
        "412" => "Etymology",
        "422" => "English etymology",
        "432" => "German etymology",
        "442" => "French etymology",
        "452" => "Italian etymology",
        "462" => "Spanish etymology",
        "472" => "Classical Latin etymology & phonology",
        "482" => "Classical Greek etymology"
    })),
    'dewey 644' => test_zci(build_structured_answer({
        "644" => "Household utilities"
    })),
    'dewey decimal system' => undef,
);

done_testing;
