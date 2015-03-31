package DDG::Goodie::2048;
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
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/2048.pm";
attribution github => ["https://github.com/puskin94", "puskin"];

# Triggers
triggers any => "game", "play";

# Handle statement
handle remainder => sub {

    (my $inputNum, my $dimension) = split/ /;

    return unless $inputNum;

    my $base = 128;

    return unless (($inputNum == $base) || # play 128
                    ($inputNum == $base*2) || # play 256
                    ($inputNum == $base*4) || # play 512
                    ($inputNum == $base*8) || # play 1024
                    ($inputNum == $base*16) || # play 2048
                    ($inputNum == $base*32) || # play 4096
                    ($inputNum == $base*64)); # play 8192


    if (!$dimension || $dimension > 10 || $dimension < 3) {
        $dimension = 4;
    }


    my $play = '<i><b>Play <span id="game">'. $inputNum .'</span> <br><br><span id="dimension">'. $dimension .'</span> x '. $dimension. '</b></i>';
    my $text = 'Play '.$inputNum;

    return $text,
    structured_answer => {
        id => '2048',
        name => '2048',
        data => $play, # I don't know how push this to the html
        templates => {
            group => 'base',
            detail => 0
            #options => {           this is not useful, duckpan takes the content.handlebars
            #   content => $play.'Goodie.2048.content'
            #}
        }
    };

};

1;
