package DDG::Goodie::Localhost;

use DDG::Goodie;

triggers query_nowhitespace => qr!^(http://)?localhost(.*)$!;

zci is_cached => 1;
zci answer_type => "localhost";

handle matches => sub {
	return "Did you mean to go to <a href='http://localhost" . $_[1] . "'>http://localhost" . $_[1] . "</a>?";
};

return 1;
