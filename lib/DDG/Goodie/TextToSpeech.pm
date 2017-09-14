package DDG::Goodie::TextToSpeech;

use DDG::Goodie;

zci answer_type => "text_to_speech";
zci is_cached   => 1;

triggers start => "text to audio", "text to speech", "text to speach", "text to voice";

handle remainder => sub {
    return '',
    structured_answer => {
        data => {
            say => $_,
        },
        templates => {
            group => 'text',
            item => 0,
            options => {
                content => 'DDH.text_to_speech.content'
            }
        }
    }
};

1;
