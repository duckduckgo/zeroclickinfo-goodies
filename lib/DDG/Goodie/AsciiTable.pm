package DDG::Goodie::AsciiTable;
# ABSTRACT: Shows Ascii Table

use DDG::Goodie;
use YAML::XS 'LoadFile';
use strict;
use warnings;

zci answer_type => 'ascii_table';

zci is_cached => 1;

my @triggers = share("triggers.txt")->slurp;

triggers startend => @triggers;

chomp(@triggers);
my $keywords = join("|", map(quotemeta, @triggers));

my $ascii = LoadFile(share('data.yml'));

handle query_lc => sub {
    s/^list of\b//;

    return unless m/$keywords/;

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
