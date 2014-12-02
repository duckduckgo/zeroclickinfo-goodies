package DDG::Goodie::Mbps2kbs;
# ABSTRACT: Convert mbps bandwidth into kb/s

use DDG::Goodie;

zci answer_type => "mbps2kbs";
zci is_cached   => 1;

name "Mbps2kbs";
description "Convert mbps bandwidth into kb/s";
primary_example_queries "1mbps in kb/s";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Mbps2kbs.pm";
attribution github => ["kethinov", "Eric Newport"],
            twitter => "kethinov";

# Triggers
triggers end => 'in kb/s';

handle remainder => sub {
	my $mbps = $_;
	my $find = "mbps";
	my $replace = "";
	$mbps =~ s/$find/$replace/g;
	my $kbps = $mbps * 125;
	return "${mbps}Mbps = $kbps kilobytes / second";
};
1;
