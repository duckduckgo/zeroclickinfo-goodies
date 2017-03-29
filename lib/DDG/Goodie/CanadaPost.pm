package DDG::Goodie::CanadaPost;
# ABSTRACT: Track a package through Canada Post

use strict;
use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "canadapost";

# Regex for Canada Post.
my $capost_qr = qr/ca(?:nada|)post(?:es|)/io;

triggers query_nowhitespace_nodash => qr/
                                         (?:^$capost_qr.*?([\d]{9,})$)|
                                         (?:^([\d]{9,}).*?$capost_qr$)|
                                         (?:^([A-Z]{2}[\d]{9}CA)$)
                                        /xio;

# Canada post package tracking.
# See http://en.wikipedia.org/wiki/Canada_Post
# See http://www.canadapost.ca/cpotools/apps/track/personal/usingTrack?execution=e3s1#Formats
handle query_nowhitespace_nodash => sub {
    my %capost_checksum = (
        '1' => 8,
        '2' => 6,
        '3' => 4,
        '4' => 2,
        '5' => 3,
        '6' => 5,
        '7' => 9,
        '8' => 7,
    );

    # If a Canada Post package number (2 for exclusively).
    my $is_capost = 0;

    # Tracking number.
    my $package_number = '';

    # Exclusive trigger.
    if ($1 || $2) {
        $package_number = $1 || $2;
        $is_capost      = 2;
    # No exclusive trigger, do checksum.
    } elsif ($3) {
        $package_number = uc $3;

        my $checksum   = 0;
        my @chars      = split(//, $package_number);
        my $length     = scalar(@chars);
        my $char_count = 0;
        my $sum        = 0;

        foreach my $char (@chars) {
            $char_count++;

            next if $char_count < 3;

            my $weight = $capost_checksum{$char_count - 2};
            $sum += $char * $weight;
            last if $char_count == 10;
        }
        $checksum = 11 - ($sum % 11);
        $checksum = 0 if $checksum == 10;
        $checksum = 5 if $checksum == 11;

        if ($checksum eq $chars[10]) {
            $is_capost = 2;
        }
    }

    # Only exclusive results right now for CA Post.
    if ($is_capost == 2) {
	my $string_answer = qq(Track this shipment at http://www.canadapost.ca/cpotools/apps/track/personal/findByTrackNumber?trackingNumber=$package_number);
	return $string_answer,
		structured_answer => {
		data => {
			package_number => $package_number
		},
		templates => {
			group => 'text',
			options => {
				content => 'DDH.canada_post.content'
			}
		}
	};
        return heading => 'Canada Post Shipment Tracking', html => qq(Track this shipment at <a href="http://www.canadapost.ca/cpotools/apps/track/personal/findByTrackNumber?trackingNumber=$package_number">Canada Post</a>.);
    }
    return;
};

1;
