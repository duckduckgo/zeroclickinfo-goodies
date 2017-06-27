#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'paper';
zci is_cached   => 1;

sub build_test {
    my ($text, $input) = @_;
    return test_zci($text, structured_answer => {
        data => {
            title => $text,
            subtitle => "Paper size: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Paper )],
    'a0 paper size' => build_test('841mm x 1189mm  (33.11in x 46.81in)', 'A0'),
    'c10 paper dimension' => build_test('28mm x 40mm  (1.10in x 1.57in)', 'C10'),
    'b10 paper dimensions' => build_test('31mm x 44mm  (1.22in x 1.73in)', 'B10'),
    'letter paper size' => build_test('8.5in x 11in (215.9mm x 279.4mm)', 'letter'),
    'legal paper dimensions' => build_test('216mm x 356mm  (8.5in x 14in)', 'legal'),
    'junior legal paper dimensions' => build_test('203mm x 127mm  (8in x 5in)', 'junior legal'),
    'ledger paper dimensions' => build_test('432mm x 279mm  (17in x 11in)', 'ledger'),
    'tabloid paper size' => build_test('279mm x 432mm  (11in x 17in)', 'tabloid'),
);

done_testing;
