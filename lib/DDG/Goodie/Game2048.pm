package DDG::Goodie::Game2048;

use DDG::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

name "2048";
description "Javascript IA for online 2048";
primary_example_queries "play 2048";
secondary_example_queries "game 2048";
category "entertainment";
topics "gaming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Game2048.pm";
attribution 
    github => ["Roysten", "Roy van der Vegt"],
    github => ["https://github.com/puskin94", "puskin"],
    github => ["https://github.com/codenirvana", "Udit Vasu"];

triggers any => "play 2048", "game 2048";

handle query_lc => sub {

    return unless $_;
   
    my $text = 'Play 2048';

    return $text,
    structured_answer => {
        id => 'game2048',
        name => '2048',
        data => {
            title => $text
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
