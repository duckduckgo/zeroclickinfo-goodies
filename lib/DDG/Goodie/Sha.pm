package DDG::Goodie::Sha;
# ABSTRACT: Compute a SHA sum for a provided string.

use DDG::Goodie;
use Digest::SHA;

zci is_cached => 1;
zci answer_type => "sha";

primary_example_queries 'SHA this';
secondary_example_queries 'sha-512 that', 'sha512sum dim-dims';
description 'SHA hash cryptography';
name 'SHA';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Sha.pm';
category 'calculations';
topics 'math';
attribution web => [ 'https://www.duckduckgo.com', 'DuckDuckGo' ],
            github => [ 'https://github.com/duckduckgo', 'duckduckgo'],
            twitter => ['http://twitter.com/duckduckgo', 'duckduckgo'];


triggers query => qr/^sha\-?(1|224|256|384|512|)(?:sum|) (hex|base64|)\s*(.*)$/i;

sub html_output {
    my ($str, $sha, $sha_version) = @_;

    # prevent XSS
    $str = html_enc($str);

    return "<div class='zci--sha'>"
          ."<span class='text--secondary'>$sha_version of \"$str\"</span><br/>"
          ."<span class='text--primary'>$sha</span>"
          ."</div>";
}

handle query => sub {
	my $command1 = $1 || '';
	my $command2 = $2 || '';
	my $str      = $3 || '';
	#warn "CMD 1: '$command1'\tCMD 2: '$command2'\tSTR: '$str'\n";

    # return if there is nothing left to hash
	return unless ($str);

	my $sha;
	if ( $command1 eq '224' ) {
	    $sha = $command2 eq 'base64' ? Digest::SHA::sha224_base64($str) : Digest::SHA::sha224_hex($str);
	}
	elsif ( $command1 eq '256' ) {
	    $sha = $command2 eq 'base64' ? Digest::SHA::sha256_base64($str) : Digest::SHA::sha256_hex($str);
	}
	elsif ( $command1 eq '384' ) {
	    $sha = $command2 eq 'base64' ? Digest::SHA::sha384_base64($str) : Digest::SHA::sha384_hex($str);
	}
	elsif ( $command1 eq '512' ) {
	    $sha = $command2 eq 'base64' ? Digest::SHA::sha512_base64($str) : Digest::SHA::sha512_hex($str);
	}
	else {
	    $command1 = '1';
	    $sha = $command2 eq 'base64' ? Digest::SHA::sha1_base64($str) : Digest::SHA::sha1_hex($str);
	}

	# pad with '=' until base64 output length is a multiple of 4
	if ($command2 eq 'base64'){
		while (length($sha) % 4) {
		    $sha .= '=';
	    }
	}
	return $sha, html => html_output($str, $sha, "SHA-$command1");
};

1;
