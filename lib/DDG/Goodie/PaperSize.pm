package DDG::Goodie::PaperSizes;
# ABSTRACT: Display various paper sizes

use DDG::Goodie;

triggers start => 'tell';

zci is_cached => 1;

primary_example_queries 'tell a4 size';
secondary_example_queries 'tell a4 dimensions';
description 'display various paper sizes';
name 'PaperSizes';
code_url 'https://github.com/xKripz/zeroclickinfo-goodies';
category 'random';
topics 'random';

attribution github => [ 'https://github.com/xKripz', 'xKripz' ];

my %papers = (
	"a0" => "841 × 1189",
	"a1" => "594 × 841",
	"a2" => "420 × 594",
	"a3" => "297 × 420",
	"a4" => "210 × 297",
	"a5" => "148 × 210",
	"a6" => "105 × 148",
	"a7" => "74 × 105",
	"a8" => "52 × 74",
	"a9" => "37 × 52",
	"a10" => "26 × 37",
);

handle remainder => sub {
	#make sure the requested paper is listed
	return unless /^(size|dimension|dimensions)\s(.+)$/i && ($papers{lc$2});

    my $query = lc $1;
	my $size  = lc $2;

    my $papers = "The fomat $papers has the dimensions $papers{$size} (mm × mm).";

    my $link = qq(More at <a href="https://en.wikipedia.org/wiki/Paper_size">Wikipedia</a>.);

    my %answer = (
        'sizes'        => [$papers, 'html' => "$papers $link"],
    );

    return @{$answer{$query}} if exists $answer{$query};

	return;
};

1;
