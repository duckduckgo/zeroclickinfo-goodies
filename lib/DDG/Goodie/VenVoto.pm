package DDG::Goodie::VenVoto;

use DDG::Goodie;
use LWP::UserAgent;

my $url = 'http://www.cne.gob.ve/web/registro_electoral/ce.php';

triggers start => 'venvoto';

my $ua = LWP::UserAgent->new;

handle remainder => sub {
    ( my $n, my $c ) = $_ =~ /^(V|E)(\d+)$/;
        return unless ( $n and $c );

        $url .= "?nacionalidad=$n&cedula=$c";
        my $res = $ua->get($url);
        return unless $res->is_success;

        ( my @parts ) = $res->decoded_content =~ m#<td align="left"><?b?>?([^<]+)<?/?b?>?</td>#g;
        return "@parts";
};

zci is_cached => 1;

1;