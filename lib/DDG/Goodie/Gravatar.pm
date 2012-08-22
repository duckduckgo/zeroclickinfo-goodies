package DDG::Goodie::Gravatar;
# ABSTRACT: Return Gravatar image given an email address 

use DDG::Goodie;
use CGI qw/img/;
use Email::Valid;
use Gravatar::URL;

triggers start => 'gravatar';

handle remainder => sub {
	if(Email::Valid->address($_)){
		return img({src=>gravatar_url(email => $_, default => "mm")});
	} else { 
		return;
	}
};

zci is_cached => 1;

1;


