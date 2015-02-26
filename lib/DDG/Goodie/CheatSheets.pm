package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files 

use JSON::XS;
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
);

attribution github  => [zachthompson => 'Zach Thompson'];

handle remainder => sub {
    # If needed we could jump through a few more hoops to check
    # terms against file names.
    my $json_path = share(join('-', split /\s+/o, lc($_) . '.json'));
    open my $fh, $json_path or return;
    my $json = do { local $/;  <$fh> };
    my $data = decode_json($json);
    return 'Vim Cheat Sheet', structured_answer => {
    	id => 'cheat_sheets',
	name => 'Cheat Sheet',
	data => $json,
	templates => {
	    group => 'base',
	    options => {
	    	content => 'DDH.cheat_sheets.content',
	    	moreAt => true
	    }
	}
    };
};

1;
