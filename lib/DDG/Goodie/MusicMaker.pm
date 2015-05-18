package DDG::Goodie::MusicMaker;

use DDG::Goodie;

zci answer_type => "music_maker";
zci is_cached   => 1;

name "MusicMaker";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";

code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/MusicMaker.pm";

triggers startend => "music maker", "musicmaker";

handle remainder => sub {

    return structured_answer => {
        id => 'music_maker',
        name => 'Music Maker',
        data => {
            title => "Music Maker"
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.music_maker.content',
                moreAt => 0
            }
        }
    };
};

1;