#!/usr/bin/env perl

use utf8;
use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'natural_to_logic';
zci is_cached   => 1;

sub build_structured_answer {
    my ($original, $answer) = @_;

    return "\"$original\" converted to formal logical notation: $answer",
        structured_answer => {
            id        => 'natural_to_logic',
            name      => 'Answer',

            data => {
                title    => $answer,
                subtitle => "Convert to formal logical notation: $original",
            },
            
            meta => {
                sourceName  => "Wikipedia",
                sourceUrl   => "https://en.wikipedia.org/wiki/List_of_logic_symbols"
            },

            templates => {
                group => 'text',
            }
        };
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::NaturalToLogic )],
    'for all x, y in M xRy implies not yRx to logic'                        => build_test('for all x, y in M xRy implies not yRx', '∀ x, y ∈ M xRy ⇒ ¬ yRx'),
    'for all as logic'                                                      => build_test('for all', '∀'),
    'for all in logic'                                                      => build_test('for all', '∀'),
    'for x exists y in all M in logical notation'                           => build_test('for x exists y in all M', 'for x ∃ y ∈ all M'),
    'exists t as logical notation'                                          => build_test('exists t', '∃ t'),
    'for all x, y exists b not b in M to logical notation'                  => build_test('for all x, y exists b not b in M', '∀ x, y ∃ b ¬ b ∈ M'),
    'as logical notation for all x, y in R (xRy and yRx) implies x = y'     => build_test('for all x, y in R (xRy and yRx) implies x = y', '∀ x, y ∈ R (xRy ∧ yRx) ⇒ x = y'),
    'in logical notation for all a, b: a = b implies f(a) = f(b)'           => build_test('for all a, b: a = b implies f(a) = f(b)', '∀ a, b: a = b ⇒ f(a) = f(b)'),
    'to logical notation for all a for all b (a = b and P(a)) implies P(b)' => build_test('for all a for all b (a = b and P(a)) implies P(b)', '∀ a ∀ b (a = b ∧ P(a)) ⇒ P(b)'),
    'in logic exists e in M for all a in M: a * e = a = e * a'              => build_test('exists e in M for all a in M: a * e = a = e * a', '∃ e ∈ M ∀ a ∈ M: a * e = a = e * a'),
    'to logic forallforeach sexists hand'                                   => build_test('forallforeach sexists hand', 'forallforeach sexists hand'),
    'xRy iff exists k in Z: x - y = k * m to logic'                         => build_test('xRy iff exists k in Z: x - y = k * m', 'xRy ⇔ ∃ k ∈ Z: x - y = k * m'),
    
    'tologic'           => undef,
    'tologic '          => undef,
    'aslogic exists in' => undef,
    'inlogic for all'   => undef,
    'to logical x'      => undef,
    'logic'             => undef,
    'logical notation'  => undef,
);

done_testing;