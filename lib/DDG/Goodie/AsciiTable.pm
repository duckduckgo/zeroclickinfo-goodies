package DDG::Goodie::AsciiTable;
# ABSTRACT: Shows Ascii Table

use DDG::Goodie;
use YAML::XS 'LoadFile';
use strict;
use warnings;

zci answer_type => 'ascii_table';

zci is_cached => 1;

triggers start => 'ascii table', 'ascii tables', 'ascii reference table',
                  'ascii reference';

my $ascii = LoadFile(share('data.yml'));

handle remainder => sub {
    return unless $_ eq '';

    return 'ASCII Table',
        structured_answer => {
            id => 'ascii_table',
            name => 'ASCII Table',
            data => {
                title => 'ASCII Table',
                ascii => $ascii
            },
            templates => {
                group => 'text',
                item => 0,
                options => {
                    content => 'DDH.ascii_table.content'
                }
            }
        };
};

1;
