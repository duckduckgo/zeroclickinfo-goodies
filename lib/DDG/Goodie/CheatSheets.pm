package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from YAML files 

use YAML::XS 'LoadFile';
use DDG::Goodie;

zci answer_type => 'cheat_sheet';
zci is_cached   => 1;

name 'CheatSheet';
description 'Cheat sheets';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CheatSheets.pm';
category 'cheat_sheets';
topics qw'computing geek programming sysadmin';

primary_example_queries 'help', 'cheat sheet', 'example';

triggers startend => (
    'cheat sheet',
    'cheatsheet',
    'guide',
    'help',
    'quick reference',
    'reference',
    'example',
    'examples',
    'example',
    'examples'
);

attribution github  => [zachthompson => 'Zach Thompson'];

handle remainder => sub {
    # If needed we could jump through a few more hoops to check
    # terms against file names.
    my $yml_path = share(join('-', split /\s+/o, lc($_) . '.yml');
    my $yml;
    eval { $yml = LoadFile($yml_path) } or do { return };
    return structured_answer => $yml;
};

1;
