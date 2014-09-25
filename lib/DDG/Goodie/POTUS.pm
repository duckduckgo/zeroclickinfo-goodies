package DDG::Goodie::POTUS;
# ABSTRACT: Returns requested President of the United States

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate qw(ordsuf ordinate);
use Lingua::EN::Words2Nums;
use URI::Escape::XS qw(uri_escape);

triggers startend => 'potus';
triggers any => 'president of the united states', 'president of the us';

zci is_cached => 1;

name 'POTUS';
description 'returns the President of the United States';
category 'reference';
topics 'trivia';
primary_example_queries 'potus 16';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/POTUS.pm';
attribution github  => ['https://github.com/numbertheory', 'John-Peter Etcheber'],
            twitter => ['http://twitter.com/jpscribbles', 'John-Peter Etcheber'];

#For maintenance, just add the president to the end of this array
my @presidents = (
    "George Washington",
    "John Adams",
    "Thomas Jefferson",
    "James Madison",
    "James Monroe",
    "John Quincy Adams",
    "Andrew Jackson",
    "Martin Van Buren",
    "William Henry Harrison",
    "John Tyler",
    "James K. Polk",
    "Zachary Taylor",
    "Millard Fillmore",
    "Franklin Pierce",
    "James Buchanan",
    "Abraham Lincoln",
    "Andrew Johnson",
    "Ulysses S. Grant",
    "Rutherford B. Hayes",
    "James A. Garfield",
    "Chester A. Arthur",
    "Grover Cleveland",
    "Benjamin Harrison",
    "Grover Cleveland",
    "William McKinley",
    "Theodore Roosevelt",
    "William Howard Taft",
    "Woodrow Wilson",
    "Warren G. Harding",
    "Calvin Coolidge",
    "Herbert Hoover",
    "Franklin D. Roosevelt",
    "Harry S. Truman",
    "Dwight D. Eisenhower",
    "John F. Kennedy",
    "Lyndon B. Johnson",
    "Richard Nixon",
    "Gerald Ford",
    "Jimmy Carter",
    "Ronald Reagan",
    "George H.W. Bush",
    "Bill Clinton",
    "George W. Bush",
    "Barack Obama",
);
		
handle remainder => sub {
	s/
      |who\s+(is|was)\s+the\s+
      |^POTUS\s+
      |\s+(POTUS|president\s+of\s+the\s+united\s+states)$
      |^(POTUS|president\s+of\s+the\s+united\s+states)\s+
    //gix;

    my $num = /\d/ ? $_ : words2nums $_;
    $num = scalar @presidents if not $num;
    return if --$num < 0 or $num > scalar @presidents;

    my $fact = ($num + 1 == scalar @presidents ? 'is' : 'was') . ' the';

    my $POTUS = 'President of the United States.';

    my $link = '<a href="https://en.wikipedia.org/wiki/'
             . uri_escape($presidents[$num]) .'">'
             . "$presidents[$num]</a>";

	return "$presidents[$num] $fact " . ordinate($num + 1) . " $POTUS",
        html => "$link $fact " . ($num + 1) . '<sup>' . ordsuf($num + 1) . "</sup> $POTUS";
};

1;

