package DDG::Goodie::IsValid::JSON;
# ABSTRACT: Check whether the submitted data is valid JSON.

use DDG::Goodie;

use Try::Tiny;
use JSON qw(from_json);

attribution github  => ['https://github.com/AlexBio', 'AlexBio'  ],
            web     => ['http://ghedini.me', 'Alessandro Ghedini'];

zci answer_type => 'isvalid';
zci is_cached   => 1;

triggers start => 'is valid json', 'validate json';

handle remainder => sub {
	my $result = try {
		from_json($_);
		return 'valid';
	} catch {
		$_ =~ /^(.* at character offset \d+ .*) at/;

		if ($1) {
			return "invalid: $1"
		} else {
			return "invalid"
		}
	};

	return "Your JSON is $result!"
};

1;
