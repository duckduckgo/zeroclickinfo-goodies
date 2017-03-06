package DDG::Goodie::MD5;
# ABSTRACT: Calculate the MD5 digest of a string.

use strict;
use utf8;
use DDG::Goodie;
use Digest::MD5 qw(md5_base64 md5_hex);
use Encode qw(encode);

zci answer_type => 'md5';
zci is_cached => 1;

triggers startend => 'md5', 'md5sum';

handle remainder => sub {
    #Remove format specifier from e.g 'md5 base64 this'
    s/^(hex|base64)\s+(.*\S+)/$2/;
    my $format = $1 || 'hex';
    s/^hash\s+(.*\S+)/$1/;    # Remove 'hash' in queries like 'md5 hash this'
    s/^of\s+(.*\S+)/$1/;      # Remove 'of' in queries like 'md5 hash of this'
    s/^"(.*)"$/$1/;           # Remove quotes

    # return if there is nothing left to hash
    return unless (/^\s*(.*\S+)/);

    # return if file extension matches
    return if (/\w\.(doc|docx|log|msg|odt|pages|rtf|tex|txt|wpd|wps|
		csv|dat|ged|key|keychain|pps|ppt|pptx|sdf|tar|
		tax2016|vcf|xml|aif|iff|m3u|m4a|mid|mp3|mpa|
		wav|wma|3g2|3gp|asf|avi|flv|m4v|mov|mp4|mpg|
		rm|srt|swf|vob|wmv|3dm|3ds|max|obj|bmp|dds|
		gif|jpg|png|psd|pspimage|tga|thm|tif|tiff|
		yuv|ai|eps|ps|svg|indd|pct|pdf|xlr|xls|xlsx|
		accdb|db|dbf|mdb|pdb|sql|apk|app|bat|cgi|com|
		exe|gadget|jar|wsf|dem|gam|nes|rom|sav|dwg|
		dxf|gpx|kml|kmz|asp|aspx|cer|cfm|csr|css|
		htm|html|js|jsp|php|rss|xhtml|crx|plugin|
		fnt|fon|otf|ttf|cab|cpl|cur|deskthemepack|
		dll|dmp|drv|icns|ico|lnk|sys|cfg|ini|prf|
		hqx|mim|uue|7z|cbr|deb|gz|pkg|rar|rpm|sitx|
		tar\.gz|zip|zipx|bin|cue|dmg|iso|mdf|toast|
		vcd|c|class|cpp|cs|dtd|fla|h|java|lua|m|pl|
		py|sh|sln|swift|vb|vcxproj|xcodeproj|bak|tmp|
		crdownload|ics|msi|part|torrent)$/i) ;

    # The string is encoded to get the utf8 representation instead of
    # perls internal representation of strings, before it's passed to
    # the md5 subroutine.
    my $str = encode("utf8", $1);
    # use approprite output format, default to hex
    # base64 padding is always '==' because hashes have a constant length
    my $md5 = $format eq 'base64' ? md5_base64($str) . '==' : md5_hex($str);

    return $md5, structured_answer => {
        data => {
            title => $md5,
            subtitle => "MD5 $format hash: $str"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
