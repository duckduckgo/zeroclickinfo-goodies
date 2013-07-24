package DDG::Goodie::POTUS;
# ABSTRACT: Returns requested President of the United States

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate;
use URI::Escape;

triggers start => 'potus';
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
	my @natnums = ('first','second', 'third', 'fourth', 'fifth', 'sixth',
		       'seventh', 'eighth', 'ninth', 'tenth', 'eleventh', 'twelfth',
		       'thirteenth', 'fourteenth', 'fifteenth', 'sixteenth', 'seventeenth',
		       'eighteenth', 'nineteenth', 'twentieth');
	my $i = 0;
	my $text = '';
	foreach $text (@natnums){
	$i = $i + 1;        
	$_ =~ s/$text/$i/gi;
	}
	s/\D+//g;
	my $num = $_;
    $num = scalar @presidents if not $num;
    return if --$num < 0 or $num > scalar @presidents;

    my $fact = ($num + 1 == scalar @presidents ? 'is' : 'was')
             . " the " . ordinate($num + 1) . " President of the United States.";

    my $link = '<a href="https://en.wikipedia.org/wiki/'
             . uri_escape($presidents[$num]) .'">'
             . $presidents[$num] . '</a>';

	return "$presidents[$num] $fact", html => "$link $fact";
};

1;

