package DDG::Goodie::CaesarCipher;
# ABSTRACT: Perform a simple Caesar cipher on some text.

use strict;
use DDG::Goodie;

triggers start => "caesar cipher", "caesar",
                  "ceasar", "ceasar cipher";

zci is_cached => 1;
zci answer_type => "caesar_cipher";

primary_example_queries 'caesar cipher 3 cipher me!';
secondary_example_queries 'caesar -1 Uijt jt b dbftbs djqifs';
description 'perform a simple Caesar cipher on some text';
name 'CaesarCipher';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CaesarCipher.pm';
category 'transformations';
topics 'cryptography';
attribution github => ['https://github.com/GuiltyDolphin', 'Ben Moon'];
