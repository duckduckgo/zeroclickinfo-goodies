package DDG::Goodie::PercentOf;
# Operations with percentuals

use DDG::Goodie;

zci answer_type => "percent_of";
zci is_cached   => 1;

name "PercentOf";
description "Makes Operations with percentuals";
primary_example_queries "4-50%", "349*16%";
secondary_example_queries "optional -- demonstrate any additional triggers";


code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/PercentOf/PercentOf.pm";
attribution github => ["puskin94", "puskin"],
            twitter => "twitterhandle";

my $result;

triggers query_raw => qr/\%$/;
 
handle query_raw => sub {	

	return unless $_ =~ qr/(\d+)(\+|\*|\/|\-)(\d+)\%/;


	if ($2 eq '-') {
		$result = ($1-(($1*$3)/100));
	} elsif ($2 eq '+') {
		$result = ($1+(($1*$3)/100));
	} elsif ($2 eq '*') {
		$result = ($1*(($1*$3)/100));
	} elsif ($2 eq '/') {
		$result = ($1/(($1*$3)/100));
	}

	return "Result: ". $result;
	
};

1;


