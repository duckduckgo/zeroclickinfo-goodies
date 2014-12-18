package DDG::Goodie::HKDK;
# ABSTRACT: Track a package through HKDK.

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "hkdk";

primary_example_queries 'CU123456789DK';
secondary_example_queries 'EE123456789HK';
description 'Track a package from Hongkong Post or Post Danmark';
name 'HK/DK';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/HKDK.pm';
category 'ids';
topics 'special_interest';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];

triggers query_nowhitespace_nodash => qr/([a-z]{2}\d{9}(?:hk|dk))/i;

handle query_nowhitespace_nodash => sub {
    my $package_number = $1;

    if ( $package_number =~ /hk$/i ) {
        return $package_number, heading => 'Hongkong Post Shipment Tracking', html => qq(Track this shipment at <a href="http://app3.hongkongpost.com/CGI/mt/genresult.jsp?tracknbr=$package_number">Hongkong Post</a>.);
    }
    elsif ( $package_number =~ /dk$/i ) {
        return $package_number, heading => 'Post Norden Shipment Tracking', html => qq(Track this shipment at <a href="http://www.postdanmark.dk/tracktrace/TrackTrace.do?i_stregkode=$package_number">Post Norden</a>.);
    }

    return;
};

1;
