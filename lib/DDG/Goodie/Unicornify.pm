package DDG::Goodie::Unicornify;
# ABSTRACT: Return Gravatar image given an email address 

use DDG::Goodie;
use CGI qw/img/;
use Email::Valid;
use Unicornify::URL;

triggers start => 'unicornify';


handle remainder => sub {
	my $link = 'http://unicornify.appspot.com/';
	if (Email::Valid->address($_)) {
		s/[\s\t]+//g; # strip whitespace from the remainder, we just need the email address.
		return  $_ . '\'s unicorn:', 
		html => $_ . '\'s unicorn <a href="'.$link.'">(Learn more at unicornify.appspot.com)</a>:'
		.'<br /><a href="' . unicornify_url(email => $_, size => 128) .'">'
		.'<img src="'.unicornify_url(email => $_, size => "100").'" style="margin: auto;" /></a>';
	}
	return;
};

zci is_cached => 1;

1;

