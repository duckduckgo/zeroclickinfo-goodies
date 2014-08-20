package DDG::Goodie::FlipText;
# ABSTRACT: appear to flip text upside down via UNICODE.

use DDG::Goodie;

use Text::UpsideDown;

triggers startend => "flip text", "mirror text", "spin text", "rotate text";

zci is_cached => 1;
zci answer_type => "flip_text";

primary_example_queries 'flip text sentence';
secondary_example_queries 'mirror text hello';
description 'flip and mirror text';
name 'FlipText';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/FlipText.pm';
category 'transformations';
topics 'words_and_games';
attribution web => [ 'robert.io', 'Robert Picard' ],
            github => [ 'http://github.com/rpicard', 'rpicard'],
            twitter => ['http://twitter.com/__rlp', '__rlp'];

handle remainder => sub {
    return unless $_;
    return upside_down( $_ );
};

1;
