#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'coin';
zci is_cached   => 0;

sub build_test {
	my ($input, $text, $title) = @_;
	return test_zci($text, structured_answer => {
		data => {
			title => $title,
			subtitle => "Flip coin: $input"
		},
		templates => {
			group => 'text'
		}
	});
}

my $single_text_re = re(qr/(heads|tails) \(random\)/);
my $single_title_re = re(qr/^(heads|tails)$/);

ddg_goodie_test(
    [qw( DDG::Goodie::Coin )],
    'flip a coin' => build_test(1, $single_text_re, $single_title_re),
    'flip coin' => build_test(1, $single_text_re, $single_title_re),
    'coin flip' => build_test(1, $single_text_re, $single_title_re),
    'coin toss' => build_test(1, $single_text_re, $single_title_re),
    'flip 1 coin' => build_test(1, $single_text_re, $single_title_re),
    'heads or tails' => build_test(1, $single_text_re, $single_title_re),
    'heads or tails?' => build_test(1, $single_text_re, $single_title_re),
	'toss a coin' => build_test(1, $single_text_re, $single_title_re),
    'toss 1 coin' => build_test(1, $single_text_re, $single_title_re),
	'flip 2 coins' => build_test(2, re(qr/(heads|tails), (heads|tails) \(random\)/), re(qr/(heads|tails), /)),
    'toss 2 coins' => build_test(2, re(qr/(heads|tails), (heads|tails) \(random\)/), re(qr/(heads|tails), /)),
    'flip 4 coins' => build_test(4, re(qr/((heads|tails),? ){4}\(random\)/), re(qr/(heads|tails),? /))
);

done_testing;
