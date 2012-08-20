package DDG::Goodie::IsValid::XML;
# ABSTRACT: Check whether the submitted data is valid XML.

use DDG::Goodie;

use Try::Tiny;
use XML::Simple;

attribution github  => ['https://github.com/ghedo', 'ghedo'      ],
            web     => ['http://ghedini.me', 'Alessandro Ghedini'];

zci answer_type => 'isvalid';
zci is_cached   => 1;

triggers any => 'xml';

handle remainder => sub {
	return unless s/ ?(is )?valid\?? ?//gi;

	my ($result, $error) = try {
		XMLin $_;
		return 'valid!';
	} catch {
		$_ =~ /^\n(.* at line \d+, column \d+, byte \d+) at/;

		return ('invalid: ', $1);
	};

	my $answer      = "Your XML is $result";
	my $answer_html = $answer;

	$answer      .= $error if $error;
	$answer_html .= "<pre style=\"font-size:12px;"
                 .  "margin-top:5px;\">$error</pre>" if $error;

	return $answer, html => $answer_html
};

1;
