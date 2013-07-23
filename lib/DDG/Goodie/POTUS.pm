package DDG::Goodie::POTUS;
# ABSTRACT: Returns requested President of the United States

use DDG::Goodie;
use Scalar::Util qw(looks_like_number);
use Lingua::EN::Numbers::Ordinate;

triggers start => 'POTUS', 'potus';
triggers any => 'president of the united states';

name 'POTUS';
description 'returns the President of the United States';
category 'reference';
topics 'trivia';
primary_example_queries 'potus 16';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/POTUS.pm';
attribution github  => ['https://github.com/numbertheory', 'John-Peter Etcheber'],
            twitter => ['http://twitter.com/jpscribbles', 'John-Peter Etcheber'];

handle remainder => sub {
	#For maintenance, just add the president to the end of this array	
	my @prez = (
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
			"Rutherfod B. Hayes",
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
		
	my $num = $_;
	$num =~ s/\D+//g;
	if (looks_like_number($num) == 0) {
		$num = scalar @prez;
		}	
	#Don't use negative numbers	
	if ($num < 1) {
		return;
		}
	#Don't answer who is the 300th president of the United States
	if ($num > scalar @prez) {
		return;
		}
		
	$num = $num - 1;
	my $verb = " was";
	if (($num+1) == scalar @prez){$verb = " is";}
	return $prez[$num], html=> "<a href=\"http://en.wikipedia.org/wiki/". $prez[$num] ."\">" . $prez[$num] . "</a>" . $verb . " the " . ordinate($num+1) . " President of the United States.";
	return;
};

zci is_cached => 1;

1;
