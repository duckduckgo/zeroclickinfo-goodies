package DDG::Goodie::PrivateNetwork;

use DDG::Goodie;
use File::ShareDir::ProjectDistDir;
use IO::All;

triggers query_clean => qr/^private (?:network|ip)s?\s*(?:(?:ips?|addresse?s?))?$/i;

zci is_cached => 1;

zci answer_type => 'network';

handle sub {
	io(dist_dir('DDG-GoodieBundle-OpenSourceDuckDuckGo').'/privatenetwork/privatenetwork.txt')->slurp,
	scalar io(dist_dir('DDG-GoodieBundle-OpenSourceDuckDuckGo').'/privatenetwork/privatenetwork.html')->slurp
};

1;
