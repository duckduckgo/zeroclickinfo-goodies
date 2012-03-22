package DDG::Goodie::Base32;

use DDG::Goodie;
use MIME::Base64 'decode_base64'; 

triggers startend => "base32";

zci answer_type => "base32_conversion";

zci is_cached => 1;

handle remainder => sub {
    return decode_base64($_) if /^[A-Za-z0-9+=]+$/;
    return;
};
1;
