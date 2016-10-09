#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'regexp';
zci is_cached   => 1;

sub build_structured_answer {
    my ($result, $expression, $text) = @_;
    return $result,
        structured_answer => {
            data => {
                title       => 'Regular Expression Match',
                subtitle    => "Match regular expression $expression on $text",
                record_data => $result,
                record_keys => \@{[sort (keys %$result)]},
            },
            meta => {
                signal => 'high',
            },
            templates => {
                group   => 'list',
                options => {
                    content => 'record',
                },
                moreAt  => 0,
            },
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test([qw( DDG::Goodie::Regexp )],
    'regexp /(?<name>Harry|Larry) is awesome/ Harry is awesome' => build_test({
        'Full Match'           => 'Harry is awesome',
        'Named Capture <name>' => 'Harry',
        'Subpattern Match 1'   => 'Harry',
    }, '/(?<name>Harry|Larry) is awesome/', 'Harry is awesome'),
    'regex /(he|she) walked away/ he walked away' => build_test({
        'Full Match'         => 'he walked away',
        'Subpattern Match 1' => 'he',
    }, '/(he|she) walked away/', 'he walked away'),
    'match regex /How are (?:we|you) (doing|today)\?/ How are you today?' => build_test({
        'Full Match'         => 'How are you today?',
        'Subpattern Match 1' => 'today',
    }, '/How are (?:we|you) (doing|today)\?/', 'How are you today?'),
    'abc =~ /[abc]+/' => build_test({
        'Full Match' => 'abc',
    }, '/[abc]+/', 'abc'),
    'DDG::Goodie::Regexp =~ /^DDG::Goodie::(?<goodie>\w+)$/' => build_test({
        'Full Match'             => 'DDG::Goodie::Regexp',
        'Named Capture <goodie>' => 'Regexp',
        'Subpattern Match 1'     => 'Regexp',
    }, '/^DDG::Goodie::(?<goodie>\w+)$/', 'DDG::Goodie::Regexp'),
    'regexp /foo/ foo' => build_test({
        'Full Match' => 'foo',
    }, '/foo/', 'foo'),
    # Modifiers
    'Foo =~ /(foo)/i' => build_test({
        'Full Match'         => 'Foo',
        'Subpattern Match 1' => 'Foo',
    }, '/(foo)/i', 'Foo'),
    'regexp /hello/i HELLO' => build_test({
        'Full Match' => 'HELLO',
    }, '/hello/i', 'HELLO'),
    # Primary example query
    'regexp /(.*)/ ddg' => build_test({
        'Full Match'         => 'ddg',
        'Subpattern Match 1' => 'ddg',
    }, '/(.*)/', 'ddg'),
    # Does not match.
    'regexp /foo/ bar'      => undef,
    'match /^foo$/ foo bar' => undef,
    # Should not trigger.
    'What is regex?'          => undef,
    'regex cheatsheet'        => undef,
    'regex'                   => undef,
    '/foo/ =~ foo'            => undef,
    'regex foo /foo/'         => undef,
    'BaR =~ /bar/x'           => undef,
    #'regexp /(?<hh(h)h>h)/ h' => undef,
);

done_testing;
