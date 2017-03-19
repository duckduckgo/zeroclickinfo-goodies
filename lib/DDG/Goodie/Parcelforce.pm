package DDG::Goodie::Parcelforce;
# ABSTRACT: track a package through Parcelforce.

use strict;
use DDG::Goodie;

zci is_cached   => 1;
zci answer_type => "parcelforce";

# Regex for parcelforce / royal mail
my $rm_qr = qr/royalmail|parcelforce/io;

my $tracking_qr = qr/package|parcel|track(?:ing|)|num(?:ber|)|\#/i;

# note: parcelforce format listed at http://www.parcelforce.com/help-information/frequently-asked-questions/track-parcel#2
my $parcel
    = qr/[A-Z]{2}[0-9]{7}|[A-Z]{4}[0-9]{10}|[A-Z]{2}[0-9]{9}GB|[0-9]{12}/i;
triggers query_nowhitespace_nodash => qr/
                                        ^$rm_qr.*?(?<parcel_number>$parcel)$|
                                        ^(?<parcel_number>$parcel).*?$rm_qr$|
                                        ^(?:$tracking_qr|$rm_qr|)*(?<parcel_number>$parcel)(?:$tracking_qr|$rm_qr|)*$
                                        /xo;

handle query_nowhitespace_nodash => sub {
    my $parcel_number = $+{parcel_number};

    if ($parcel_number && $parcel_number !~ /^(isbn|luhn|kb)/i) {

        return $parcel_number,
            heading => 'Parcelforce Tracking',
            html =>
            qq(Track this parcel at <a href="http://www.parcelforce.com/track-trace?trackNumber=$parcel_number">Parcelforce</a>.);

    };
    return;
};
1;
