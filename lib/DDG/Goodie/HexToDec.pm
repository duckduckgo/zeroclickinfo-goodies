package DDG::Goodie::HexToDec;

# ABSTRACT: hexadecimal number to decimal

use DDG::Goodie;
zci is_cached => 1;
zci answer_type => "hexadecimal conversion";

primary_example_queries 'hextodec ff';

description 'Convert hexadecimal number to decimal number';
name 'HexToDec';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/HexToDec.pm';
category 'conversions';
topics 'math';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];


triggers start => 'hextodec';

handle remainder => sub{

#convert to decimal number from hexadecimal number
if($_)
{

$_ =~ s/^\s*(.*?)\s*$/$1/;
eval{my $decimal_value = hex($_)};
if($@){
	return;
}
else{
my $decimal_value = hex($_);
return 'Decimal Value: '.$decimal_value;
}
}
else
{
return;
}
};




1;