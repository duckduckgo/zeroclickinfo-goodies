package DDG::Goodie::Unicornify;
# ABSTRACT: Return Gravatar image given an email address

use DDG::Goodie;
use CGI qw/img/;
use Email::Valid;
use Unicornify::URL;

triggers start => 'unicornify';
attribution github => ['flaming-toast', 'Jessica Yu'];

handle remainder => sub {
	my $link = 'http://unicornify.appspot.com/';
	if (Email::Valid->address($_)) {
		s/[\s\t]+//g; # strip whitespace from the remainder, we just need the email address.
		my $answer = 'This is a unique unicorn for ' . $_ . ':' . "\nLearn more at unicornify.appspot.com";
		my $heading =  $_ . ' (Unicornify)';
		my $html = 'This is a unique unicorn for ' . $_ . ':'
		.'<br /><a href="' . unicornify_url(email => $_, size => 128) .'">'
		.'<img src="/iu/?u='.unicornify_url(email => $_, size => "100").'" class="zci--unicornify-img" /></a>'
		. 'Learn more at <a href="'.$link.'">unicornify.appspot.com</a>';

		return $answer, heading => $heading, html => $html;
	}
	return;
};

zci is_cached => 1;

1;

