package DDG::Goodie::FlipText;
# ABSTRACT: appear to flip text upside down via UNICODE.

use DDG::Goodie;

use Text::UpsideDown;

triggers startend => "flip text", "mirror text", "spin text", "rotate text";

zci answer_type => "flip_text";
zci is_cached   => 1;

primary_example_queries 'flip text sentence';
secondary_example_queries 'mirror text hello';
description 'flip and mirror text';
name 'FlipText';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FlipText.pm';
category 'transformations';
topics 'words_and_games';
attribution web     => ['robert.io',                 'Robert Picard'],
            github  => ['http://github.com/rpicard', 'rpicard'],
            twitter => ['http://twitter.com/__rlp',  '__rlp'];

handle remainder => sub {
    my $input = $_;

    return unless $input;

    my $result = upside_down($input);

    return $result,
      structured_answer => {
        input     => [html_enc($input)],
        operation => 'Flip text',
        result    => html_enc($result),
      };
};

1;
