package DDG::Goodie::MagicEightBall;
# ABSTRACT: provides a random answer just like a magic eight ball

use DDG::Goodie;
use strict;

zci answer_type => "magic_eight_ball";
zci is_cached   => 1;

name "MagicEightBall";
description "provides a random answer just like a magic eight ball";
primary_example_queries "magic eight ball is it going to rain today", "magic 8 ball should I wear red today?";
secondary_example_queries "are you actually helpful magic eight ball";
category "random";
topics "trivia";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MagicEightBall.pm";
attribution github => ["jlbaez", "Jose Baez"];

triggers startend => "magic eight ball", "magic 8 ball";

handle remainder => sub {
    return unless $_;

    #These are the standard responses found in a magic eight ball
    my @eightBallresponses = ("It is certain",
        "It is decidedly so",
        "Without a doubt",
        "Yes, definitely",
        "You may rely on it",
        "As I see it, yes",
        "Most likely",
        "Outlook good",
        "Yes",
        "Signs point to yes",
        "Reply hazy try again",
        "Ask again later",
        "Better not tell you now",
        "Cannot predict now",
        "Concentrate and ask again",
        "Don't count on it",
        "My reply is no",
        "My sources say no",
        "Outlook not so good",
        "Very doubtful"
    );

    my $response = $eightBallresponses[int rand scalar @eightBallresponses];

    return $response,
        structured_answer => {
            input => [html_enc($_)],
            operation => "Magic eight ball's answer to",
            result => html_enc($response),
        };
};

1;
