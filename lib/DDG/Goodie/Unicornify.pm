package DDG::Goodie::Unicornify;
# ABSTRACT: Return Unicornify image given an email address

use strict;
use DDG::Goodie;
use CGI qw/img/;
use Email::Valid;
use Unicornify::URL;

zci answer_type => "unicornify";

zci is_cached => 1;
triggers startend => 'unicornify';

handle remainder => sub {
	if (Email::Valid->address($_)) {
		s/[\s\t]+//g; # strip whitespace from the remainder, we just need the email address.
		
        return "This is a unique unicorn for $_",
        structured_answer => {
            data => {
                subtitle => "Unique unicorn",
                title => "$_",
                url => unicornify_url(email => $_, size => "200"),
                image => unicornify_url(email => $_, size => "100")
            },
            meta => {
                sourceName => "Unicornify",
                sourceUrl => 'http://unicornify.appspot.com/'
            }, 
            templates => {
                group => "icon",
                item => 0,
                moreAt => 1,
                variants => {
                    iconTitle => 'large',
                    iconImage => 'large'
                }
            }
        }
	}
	return;
};

1;

