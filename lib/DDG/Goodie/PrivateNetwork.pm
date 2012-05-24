package DDG::Goodie::PrivateNetwork;

use DDG::Goodie;

triggers query_clean => qr/^private (?:network|ip)s?\s*(?:(?:ips?|addresse?s?))?$/i;

zci is_cached => 1;
zci answer_type => "private_network";

handle sub {
	scalar share('private_network.txt')->slurp,
	html => scalar share('private_network.html')->slurp;
};

1;
