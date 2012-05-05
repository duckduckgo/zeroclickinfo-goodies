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

    my $str = join(' ',@_);

    my $html = HTML::Barcode::QRCode->new(text => $str)->render;

    $html = qq( <div style="float:left;margin-right:10px;">$html</div> A QR code that means '$str'. <div class="clear"></div>);

    return '', html => $html;
};

1;
