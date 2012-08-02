package DDG::Goodie::IsValid::XML;

use DDG::Goodie;

use Try::Tiny;
use XML::Simple;

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
