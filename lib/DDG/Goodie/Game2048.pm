package DDG::Goodie::Game2048;

use DDG::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

triggers any => "play 2048", "game 2048";

handle query_lc => sub {

    return unless $_;

    return '',
    structured_answer => {
        id => 'game2048',
        name => '2048',
        data => { },
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
