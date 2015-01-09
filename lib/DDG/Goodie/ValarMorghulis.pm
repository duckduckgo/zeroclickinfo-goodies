package DDG::Goodie::ValarMorghulis;
# ABSTRACT: A Game of Thrones / A Song of Ice and Fire easter egg.

use utf8;
use DDG::Goodie;

triggers start => 'valar morghulis';
primary_example_queries 'valar morghulis';

name 'Valar Morghulis';
description 'Game of Thrones / A Song of Ice and Fire easter egg.';
category 'special';
topics 'geek';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ValarMorghulis.pm';
attribution web    => ['http://engvik.nu', 'Lars Jansøn Engvik'],
            github => ['larseng',          'Lars Jansøn Engvik'];

zci answer_type => 'valar_morghulis';
zci is_cached   => 1;

handle remainder => sub {
    return unless ($_ eq '');

    my $answer = 'Valar dohaeris';

    return $answer,
      structured_answer => {
        input     => ['Valar morghulis'],
        operation => 'Code phrase',
        result    => $answer
      };
};

1;
