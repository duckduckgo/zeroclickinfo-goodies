#!/usr/bin/env perl

use strict;
use warnings;

use Test::Most;

# Just so we don't have to type cmp_deeply over and over...
sub t { cmp_deeply(@_) }

sub parse_test {
    my ($to_parse, $expected) = @_;
    my $parsed = ListTester::parse_list($to_parse);
    t($parsed, $expected, "parse $to_parse");
}

subtest initialization => sub {
    { package ListTester; use Moo; with 'DDG::GoodieRole::Parse::List'; 1; }

    new_ok('ListTester', [], 'Applied to a class');
};

subtest parse_list => sub {
    subtest 'varying brackets' => sub {
        my %brackets = (
            '[' => ']',
            '{' => '}',
            '(' => ')',
            ''  => '',
        );
        while (my ($open, $close) = each %brackets) {
            my $test_list = "${open}1, 2, 3$close";
            my $expected  = [1, 2, 3];
            subtest "brackets: $open$close" => sub {
                parse_test($test_list, $expected);
            };
        }
    };

    subtest 'number of items' => sub {
        my %tcs = (
            0 => '[]',
            1 => '[1]',
            2 => '[1, 2]',
            4 => '[1, 2, 3, 4]',
        );
        while (my ($amount, $tstring) = each %tcs) {
            subtest "$amount items" => sub {
                parse_test($tstring, arraylength($amount));
            };
        }
    };
};

done_testing;

1;
