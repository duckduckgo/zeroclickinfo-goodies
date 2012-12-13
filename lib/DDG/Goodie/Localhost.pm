package DDG::Goodie::Localhost;
# ABSTRACT: Return a hyperlink to the localhost web server

use strict;

use DDG::Goodie;

triggers start => 'localhost';

zci is_cached => 1;
zci answer_type => 'localhost';

primary_example_queries 'localhost';
description 'Just return a hyperlink to the local web server.';
name 'localhost';
code_url 'https://github.com/koosha--/zeroclickinfo-goodies';
category 'computing_tools';
attribution github => ['https://github.com/koosha--', 'koosha--'],
			twitter => '_koosha_';

handle remainder => sub {
    s/^\s+//;
    s/\s+$//;
    unless ($_) {
        return answer => 'http://localhost', html => '<a href="http://localhost">http://localhost</a>'
    }
    return;
};

1;
