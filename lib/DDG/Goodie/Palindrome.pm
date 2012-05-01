package DDG::Goodie::Palindrome;
# ABSTRACT: Return if the a string is a palindrome, formatted like: is <string> a palindrome

use DDG::Goodie;

triggers query_clean => qr/(^is\s)|\s((a|an)\s)(palindrome\?$|palindrome$)|(^isPalindrome)/i;

handle query_clean => sub {

	#Remove the trigger text from the query.
	$query = $_ if $_ =~ s/(^is\s)|\s((a|an)\s)(palindrome\?$|palindrome$)|(^isPalindrome)//g;

	#Return if no parameter is passed/matched.
	return if !$query;

	#Reverse the string.
	$rev = (scalar reverse $query);

	$resp = $query . " is not a palindrome.";

	#Check to see if it is a palindrome.
	$resp = $query . " is a palindrome!" if ($query eq $rev);
    return $resp;
};

zci is_cached => 1;

1;