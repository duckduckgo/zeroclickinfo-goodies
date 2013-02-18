package DDG::Goodie::UserAgent;

use DDG::Goodie;
use CGI::Simple;

zci answer_type => "user-agent";

triggers query_lc => qr/^user(\s+|\-)?agent(\s+me)?$/i;

handle query => sub {
	my $query = new CGI::Simple;
	my $user_agent = $query->user_agent() || '';
};

1;