package DDG::Goodie::PrivateNetwork;

use DDG::Goodie;
use File::ShareDir::ProjectDistDir;
use IO::All;

triggers query_clean => qr/^private (?:network|ip)s?\s*(?:(?:ips?|addresse?s?))?$/i;

zci is_cached => 1;

zci answer_type => 'network';

handle sub {
    my $sharedir = dist_dir('zeroclickinfo-goodies');

    my $lines = io("$sharedir/privatenetwork/privatenetwork.html")->slurp;
    
    return $lines;
};
1;
