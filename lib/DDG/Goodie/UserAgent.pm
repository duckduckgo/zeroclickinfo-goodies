package DDG::Goodie::UserAgent;

use DDG::Goodie;
use CGI::Simple;

zci answer_type => "user-agent";
triggers query_lc => qr/user(\s+|\-)?agent/i;

handle query_lc => sub {
	my %user_agent_qr = (
		'useragent',
		'useragent me',
		'show useragent',
		'my useragent',
		'what is my useragent',
		'what\'s my useragent',
		'user agent',
		'user agent me',
		'show user agent',
		'my user agent',
		'what is my user agent',
		'what\'s my user agent',
		'user-agent',
		'user-agent me',
		'show user-agent',
		'my user-agent',
		'what is my user-agent',
		'what\'s my user-agent',
	);
	# Return if it doesn't exist in the dictionary.
	return unless exists $user_agent_qr{$_};

	return $user_agent;
};

1;