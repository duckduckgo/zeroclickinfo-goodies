package DDG::Goodie::PublicDNS;

use DDG::Goodie;
use File::ShareDir::ProjectDistDir;
use IO::All;

triggers query_clean => qr/^(?:google|opendns|norton|dns advantage)?\s*public dns\s*(?:servers?)?$/i;

zci is_cached => 1;

zci answer_type => 'dns';

handle sub {
    my $sharedir = dist_dir('zeroclickinfo-goodies');

    my @lines = io("$sharedir/publicdns/publicdns.html")->slurp;
    
    my $output;
    $output .= $_ for @lines;
    return $output;
};

1;
