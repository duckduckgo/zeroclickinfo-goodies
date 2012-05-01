package DDG::Goodie::QRCode;
# ABSTRACT: Generate a QR Code barcode.

use DDG::Goodie;
use HTML::Barcode::QRCode;

triggers start => 'qr', 'qrcode';
zci is_cached => 1;
zci answer_type => "qrcode";

handle query_parts => sub {
    if (lc(shift) eq 'qr') {
        return unless lc(shift) eq "code";
    }
    return '', html => HTML::Barcode::QRCode->new(text => join(' ',@_))->render;
};

1;
