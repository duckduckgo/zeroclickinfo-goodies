package DDG::Goodie::CheatSheets;
# ABSTRACT: Load basic cheat sheets from JSON files 

use JSON::XS;
use DDG::Goodie;

zci answer_type => 'cheat_sheet';
zci is_cached   => 1;

name 'CheatSheets';
description 'Cheat sheets';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/CheatSheets.pm';
category 'cheat_sheets';
topics qw'computing geek programming sysadmin';

primary_example_queries 'universal help', 'universal cheat sheet', 'universal example';

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
	my @data;
	for my $s (@{$data->{section_order}}){
		my %record_data;
		for my $t (@{$data->{sections}{$s}}){
			$record_data{$t->{key}} = $t->{val};
		}
		push @data, {title => $s, record_data => \%record_data};	
	}
    return 'Vim Cheat Sheet', structured_answer => {
    	id => 'cheat_sheets',
		name => 'Cheat Sheets',
		data => \@data,
		templates => {
			group => 'base',
			options => {
				content => 'record',
				moreAt => true,
				rowHighlight => true
			}
		},
		meta => {
			sourceName => 'duckduckgo',
			sourceURL => 'https://duckduckgo.com'
		}
    };
};

1;
