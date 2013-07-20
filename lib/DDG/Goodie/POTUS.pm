package DDG::Goodie::POTUS;
# ABSTRACT: Returns requested President of the United States

use DDG::Goodie;
use Scalar::Util qw(looks_like_number);

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
	my $num = $_;
	$num =~ s/\D+//g;
	if (looks_like_number($num) == 0) {
		$num = 44;
		}	
	#Don't use negative numbers	
	if ($num < 1) {
		return;
		}
	#There are only 44 Presidents so far
	if ($num > 44) {
		return;
		}
		
	$num = $num - 1;
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
			"Barack Obama"
				);
	my @label = ( "th","st","nd","rd","th","th","th","th","th","th",
		   "th","th","th","th","th","th","th","th","th","th",
		   "th","st","nd","rd","th","th","th","th","th","th",
		   "th","st","nd","rd","th","th","th","th","th","th",
		   "th","st","nd","rd","th"
			);
	my $verb = " was";
	if (($num+1) == 44){$verb = " is";}
	return $prez[$num] . $verb . " the " . ($num+1) . $label[$num+1] . " President of the United States.";
	return;
};

zci is_cached => 1;

1;
