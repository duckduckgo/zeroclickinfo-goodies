package DDG::Goodie::Gravatar;
# ABSTRACT: Returns the gravatar image URL of a given email address

use strict;

use DDG::Goodie;
use Digest::MD5 'md5_hex';
use Email::Valid;

# Size of the square avatar
use constant SIZE => 100;
# The default avatar
use constant DEFAULT => 'mm';

triggers start => 'gravatar';

zci is_cached => 1;

primary_example_queries 'gravatar user@example.com';
secondary_example_queries 'gravatar john@example.net';
description 'Return the gravatar image URL of the given email address';
name 'Gravatar';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies';
category 'computing_tools';
topics 'programming';
attribution github => ['https://github.com/koosha--', 'koosha--'],
			twitter => '_koosha_';

handle remainder => sub {
    s/^\s+//;
    s/\s+$//;
    my $email = lc $_;
    if (scalar Email::Valid->address($email)) {
        my $md5 = md5_hex($email);
        # Serve the SSL URL to avoid browser warnings
        my $url = "https://secure.gravatar.com/avatar/$md5?d=".DEFAULT."&s=" . SIZE;
        return answer => $url, html => "<img src='$url' />";
    }
    return;
};

1;
