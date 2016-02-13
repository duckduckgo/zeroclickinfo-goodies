#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => "magic_eight_ball";
zci is_cached   => 0;

my $possibleAnswers = qr/(It is certain|It is decidedly so|Without a doubt|Yes, definitely|You may rely on it|As I see it, yes|Most likely|Outlook good|Yes|Signs point to yes|Reply hazy try again|Ask again later|Better not tell you now|Cannot predict now|Concentrate and ask again|Don't count on it|My reply is no|My sources say no|Outlook not so good|Very doubtful)/;

my $possibleStructuredAnswer = qr/^(?:It is certain|It is decidedly so|Without a doubt|Yes, definitely|You may rely on it|As I see it, yes|Most likely|Outlook good|Yes|Signs point to yes|Reply hazy try again|Ask again later|Better not tell you now|Cannot predict now|Concentrate and ask again|Don&#39;t count on it|My reply is no|My sources say no|Outlook not so good|Very doubtful)$/;

ddg_goodie_test(
    [qw( DDG::Goodie::MagicEightBall )],
    'magic eight ball is it going to rain today' => test_zci(
        $possibleAnswers,
        structured_answer => {
            input     => ['is it going to rain today'],
            operation => "Magic eight ball's answer to",
            result    => $possibleStructuredAnswer,
        }
    ),
    'magic 8 ball should I wear red today?' => test_zci(
        $possibleAnswers,
        structured_answer => {
            input     => ['should I wear red today?'],
            operation => "Magic eight ball's answer to",
            result    => $possibleStructuredAnswer,
        }
    ),
    'magic eight-ball are you actually helpful' => test_zci(
        $possibleAnswers,
        structured_answer => {
            input     => ['are you actually helpful'],
            operation => "Magic eight ball's answer to",
            result    => $possibleStructuredAnswer,
        }
    ),
    'eight ball will this work?' => undef,
    'magic 8ball Yes?' => undef,
    'magic 8ball' => undef
);

done_testing;
