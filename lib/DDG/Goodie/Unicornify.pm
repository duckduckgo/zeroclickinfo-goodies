package DDG::Goodie::Unicornify;
# ABSTRACT: Return Unicornify image given an email address

use strict;
use DDG::Goodie;
use CGI qw/img/;
use Email::Valid;
use Unicornify::URL;

zci answer_type => "unicornify";

primary_example_queries 'unicornify test@example.com';
description 'Unicornify an email address';
name 'Unicornify';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Unicornify.pm';
category 'special';
topics 'special_interest', 'geek';
attribution github => ['flaming-toast', 'Jessica Yu'],
            github => ['https://github.com/Sloff', 'Sloff'];
            
zci is_cached => 1;
triggers startend => 'unicornify';

handle remainder => sub {
	if (Email::Valid->address($_)) {
		s/[\s\t]+//g; # strip whitespace from the remainder, we just need the email address.
		
        return "This is a unique unicorn for $_",
        structured_answer => {
            id => "unicornify",
            name => "Social",
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

