package DDG::GoodieRole::ImageLoader;
# ABSTRACT: A role to allow Goodies to load images to pretty up their output.

use strict;
use warnings;
use feature 'state';

use Moo::Role;

use List::MoreUtils qw( all );
use MIME::Base64;
use MIME::Types;
use Scalar::Util qw( reftype );
use Try::Tiny;

# Key and whether or not it is required
my %known_keys = (
    filename => 1,
    alt      => 0,
    height   => 0,
    width    => 0,
    class    => 0,
);

my $mt = MIME::Types->new(
    only_complete => 1,
    only_iana     => 1
);

#  Returns an empty tag ('') in case of error.
my $cannot = '';
sub goodie_img_tag {
    my $req_ref = shift;

    # They must give us a hashref.
    my $ref_val = reftype($req_ref) || '';
    return $cannot unless ($ref_val eq 'HASH');
    my %request = %$req_ref;
    # And we must know what they all mean.
    return $cannot unless (all { exists $known_keys{$_} } (keys %request));
    # And all required ones must be present;
    return $cannot unless (all { exists $request{$_} } grep { $known_keys{$_} } (keys %known_keys));
    # We need to know the type of the file and that it's an image
    my $filename = $request{filename};
    my $type     = $mt->mimeTypeOf($request{filename});
    return $cannot unless ($type && (split '/', $type)[0] eq 'image');
    # Now we need to hook into the role consumer's share dir, which we do in a ugly way here.
    state $their_share = _caller_to_share(caller);
    # Now we need to be sure that we can get at the file
    # Even if they turn out not to even have a share dir.
    my $file = try { $their_share->($filename) };
    return $cannot unless $file;
    my $contents = scalar $file->slurp(iomode => '<:bytes');
    # Reckon it's possible they tried to trick us with an empty file
    return $cannot unless $contents;
    my $b64_contents = encode_base64($contents, '');
    return $cannot unless $b64_contents;
    state $their_enc = _caller_to_enc(caller);

    my $goodie_tag = '<img src="data:' . $type . ';base64,' . $b64_contents . '"';
    foreach my $img_attr (grep { defined $request{$_} } qw(alt class height width)) {
        $goodie_tag .= ' ' . $img_attr . '="' . $their_enc->($request{$img_attr}) . '"';
    }
    $goodie_tag .= '/>';

    return $goodie_tag;
}

sub _caller_to_share {
    my $package    = shift;
    my $share_func = $package . '::share';
    return \&$share_func;
}

sub _caller_to_enc {
    my $package  = shift;
    my $enc_func = $package . '::html_enc';
    return \&$enc_func;
}

1;
