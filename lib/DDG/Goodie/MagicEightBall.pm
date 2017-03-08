package DDG::Goodie::MagicEightBall;
# ABSTRACT: provides a random answer just like a magic eight ball

use DDG::Goodie;
use strict;

zci answer_type => "magic_eight_ball";
zci is_cached   => 0;

triggers start => "magic eight ball", "magic 8 ball", "magic eight-ball", "magic 8-ball", "magic 8ball";

#These are the standard responses found in a magic eight ball
my @eightBallresponses = (
    "It is certain",
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

handle remainder => sub {
    #only 2 words or more
    return unless /\S \S/;

    srand();
    my $response = $eightBallresponses[int rand scalar @eightBallresponses];

    return $response, structured_answer => {
        data => {
            title => $response,
            subtitle => "Magic eight ball's answer to: $_"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
