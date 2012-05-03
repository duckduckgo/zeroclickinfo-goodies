package DDG::Goodie::Palindrome;
# ABSTRACT: Return if the a string is a palindrome, formatted requests: 
#    'is <string> a[n] palindrome[?]' or 'isPalindrome <string>'

use DDG::Goodie;

triggers any => 'palindrome';

handle query_clean => sub {

	#Remove the trigger text from the query.
	return unless /^is \s+ (\S+) \s+ an? \s* palindrome\??$/ix;

	#Check to see if it is a palindrome.
	return ($1 eq scalar reverse $1) ? "$1 is a palindrome." : "$1 is not a palindrome.";
};

zci is_cached => 1;

1;