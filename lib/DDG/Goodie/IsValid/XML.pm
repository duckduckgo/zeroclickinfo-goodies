package DDG::Goodie::IsValid::XML;
# ABSTRACT: Check whether the submitted data is valid XML.

use DDG::Goodie;

use Try::Tiny;
use XML::Simple;

attribution github  => ['https://github.com/AlexBio', 'AlexBio'  ],
            web     => ['http://ghedini.me', 'Alessandro Ghedini'];

zci answer_type => 'isvalid';
zci is_cached   => 1;

triggers start => 'is valid xml', 'validate xml';

handle remainder => sub {
	my $result = try {
		XMLin($_);
		return 'valid';
	} catch {
		return 'invalid';
	};

	return "Your XML is $result!";
};

1;
