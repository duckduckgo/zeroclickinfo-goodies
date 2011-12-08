#
# Convert Base64 strings to base32
#

use MIME::Base64 qw(decode_base64);

if ($q_check =~ /^base32 ([A-Za-z0-9+=]+)$/) {
    $answer_results = decode_base64($1);
    $answer_type = "convert";
}
