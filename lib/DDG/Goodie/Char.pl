package DDG::Goodie::Char;

use DDG::Goodie;

triggers start => 'char';

handle remainder => sub {

	return 'Chars: ' . length $_ if $_;
	return;
};
1;

