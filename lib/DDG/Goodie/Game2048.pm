package DDG::Goodie::Game2048;

use DDG::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

triggers start => "2048", "play 2048", "game 2048";

handle query_lc => sub {

    return unless $_ =~ /^(2048|play 2048|game 2048)(\s+.*)*$/;

    return '',
    structured_answer => {
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
