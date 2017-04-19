package DDG::Goodie::AsciiTable;
# ABSTRACT: Shows Ascii Table

use DDG::Goodie;
use YAML::XS 'LoadFile';
use strict;
use warnings;

zci answer_type => 'ascii_table';

zci is_cached => 1;

triggers start => 'ascii table', 'ascii tables', 'ascii reference table',
                  'ascii reference', 'ascii codes', 'char codes', 'character codes', 
                  'ascii character codes', 'ascii characters', 'ascii character table', 'ascii characters table',
                  'ascii chart', 'ascii codes chart', 'ascii characters chart';

my $ascii = LoadFile(share('data.yml'));

handle remainder => sub {
    return unless $_ eq '';

    return '',
        structured_answer => {
            id => 'ascii_table',
            name => 'ASCII Table',
            data => {
                title => 'ASCII Table',
                table => $ascii
            },
            meta => {
                sourceName => 'asciitable.com',
                sourceUrl => 'http://www.asciitable.com/'
            },
            templates => {
                group => 'list',
                item => 0,
                options => {
                    content => 'DDH.ascii_table.content',
                    moreAt => 1
                }
            }
        };
};

1;
