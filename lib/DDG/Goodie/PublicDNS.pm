package DDG::Goodie::PublicDNS;

use DDG::Goodie;
use File::ShareDir::ProjectDistDir;
use IO::All;

triggers end => "public dns", "dns servers";

zci is_cached => 1;
zci answer_type => "public_dns";

handle sub {
	scalar share('publicdns.txt')->slurp,
	html => scalar share('publicdns.html')->slurp;
};

1;
