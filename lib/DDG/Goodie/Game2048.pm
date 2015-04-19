package DDG::Goodie::Game2048;
# Play (128|256|512|1024|2048|4096|8192) online!!

use DDG::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

name "2048";
description "Javascript IA for online 2048";
primary_example_queries "2048 game", "play 512";
secondary_example_queries "play 4096";
category "entertainment";
topics "gaming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Game2048.pm";
attribution github => ["https://github.com/puskin94", "puskin"];

triggers any => "game", "play";

handle remainder => sub {

    (my $inputNum, my $dimension) = split/ /;

    # Play 128, 256, 512, 1024, 2048, 4096, 8192
    return unless $inputNum % 128 == 0 && $inputNum <= 8192;

    if (!$dimension || $dimension > 10 || $dimension < 3) {
        $dimension = 4;
    }

    my $text = 'Play '.$inputNum;

    return $text,
    structured_answer => {
        id => 'game2048',
        name => '2048',
        data => {
            inputNum => $inputNum,
            dimension => $dimension
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.game2048.content'
            }
        }
    };

};

1;
