package DDG::Goodie::Unicornify;
# ABSTRACT: Return Gravatar image given an email address 

use DDG::Goodie;
use CGI qw/img/;
use Email::Valid;
use Unicornify::URL;

triggers start => 'unicornify';

handle remainder => sub {
	return img({src=>unicornify_url(email => $_, size => "100")}) if (Email::Valid->address($_));
	return;
};

zci is_cached => 1;

1;

