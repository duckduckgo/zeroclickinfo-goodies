package DDG::Goodie::Palindrome;
# ABSTRACT: Return if the a string is a palindrome, formatted requests:
#    'is <string> a[n] palindrome[?]' or 'isPalindrome <string>'

use strict;
use DDG::Goodie;

triggers any => 'palindrome';

zci is_cached => 1;

handle query => sub {
	#Remove the trigger text from the query.
	return unless /^(?:is\s+|)(.*?)\s+an?\s*palindrome\??$/i;

	my $palindrome = $1;

	my $is_palindrome = 0;

	# Clean up.
	my $clean_palindrome = lc $palindrome;
	$clean_palindrome =~ s/[^a-z0-9]+//g;

	$is_palindrome = 1 if $clean_palindrome eq scalar reverse $clean_palindrome;

	#Check to see if it is a palindrome.
	return $is_palindrome ? qq("$palindrome" is a palindrome.) : qq("$palindrome" is not a palindrome.);
};

1;
