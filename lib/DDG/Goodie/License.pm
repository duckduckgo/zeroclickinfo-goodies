package DDG::Goodie::License;

use DDG::Goodie;

name 'License';
description 'Shows the content of a certain open-source license';
primary_example_queries 'mozilla license';
category 'reference';
topics 'geek';
code_url 'https://github.com/yzwx/zeroclickinfo-goodies/blob/license/lib/DDG/Goodie/License.pm';
attribution github => ['https://github.com/yzwx', 'yzwx'];

triggers startend => (
	'license',
	'licence'
);

zci answer_type => 'license';
zci is_cached => 1;

my $apache = share('apache.html')->slurp;
my $bsd2 = share('bsd2.html')->slurp;
my $bsd3 = share('bsd3.html')->slurp;
my $mit = share('mit.html')->slurp;
my $mozilla = share('mozilla.html')->slurp;

handle remainder => sub {
    if (lc $_ eq 'apache') {
	return heading => 'Apache License 2.0', html => $apache;
    } elsif ($_ =~ /(freebsd|bsd(2| 2|-2))/i) {
	return heading => 'BSD 2-Clause License', html => $bsd2;
    } elsif ($_ =~ /(new bsd|bsd(3| 3|-3))/i) {
	return heading => 'BSD 3-Clause License', html => $bsd3;
    } elsif (lc $_ eq 'mit') {
	return heading => 'MIT License', html => $mit;
    } elsif (lc $_ eq 'mozilla') {
	return heading => 'Mozilla Public License 2.0', html => $mozilla;
    } else {
	return;
    }
};


1;
