#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "magic_eight_ball";
zci is_cached   => 0;

my $possibleAnswers = re(qr/(It is certain|It is decidedly so|Without a doubt|Yes, definitely|You may rely on it|As I see it, yes|Most likely|Outlook good|Yes|Signs point to yes|Reply hazy try again|Ask again later|Better not tell you now|Cannot predict now|Concentrate and ask again|Don't count on it|My reply is no|My sources say no|Outlook not so good|Very doubtful)/);

sub build_test {
    my ($input) = @_;
    return test_zci($possibleAnswers, structured_answer =>{
        data => {
            title    => $possibleAnswers,
            subtitle => "Magic eight ball's answer to: $input"
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::MagicEightBall )],
    'magic eight ball is it going to rain today' => build_test('is it going to rain today'),
    'magic 8 ball should I wear red today?'      => build_test('should I wear red today?'),
    'magic eight-ball are you actually helpful'  => build_test('are you actually helpful'),
    'eight ball will this work?' => undef,
    'magic 8ball Yes?'           => undef,
    'magic 8ball'                => undef
);

done_testing;
