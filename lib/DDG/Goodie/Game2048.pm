package DDG::Goodie::Game2048;
# Play (128|256|512|1024|2048|4096|8192) online!!

use DDG::Goodie;

zci answer_type => "2048";
zci is_cached   => 1;

name "2048";
description "Javascript IA for online 2048";
primary_example_queries "play 512";
secondary_example_queries "play 4096";
category "entertainment";
topics "gaming";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Game2048.pm";
attribution 
    github => ["Roysten", "Roy van der Vegt"],
    github => ["https://github.com/puskin94", "puskin"];

my @game_modes = qw (128 256 512 1024 2048 4096 8192);
my @triggers = map { "play $_" } @game_modes;
triggers start => @triggers;

handle query_lc => sub {

    return unless $_ =~ qr#^play\s(?<inputNum>\d{3,4})\s*(?<dimension>\d{1,2})*$#;
    my $inputNum = $+{inputNum};
    my $dimension = $+{dimension};

    if (!$dimension || $dimension > 10 || $dimension < 3) {
        $dimension = 4;
    }

    my $text = 'Play ' . $inputNum;

    return $text,
    structured_answer => {
        id => 'game2048',
        name => '2048',
        data => {
            title => $text,
            subtitle => $dimension . 'x' . $dimension,
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
