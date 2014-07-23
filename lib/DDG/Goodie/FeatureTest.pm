package DDG::Goodie::FeatureTest;

use DDG::Goodie;
use utf8;

triggers any => "test all the plugin features";

handle sub {
	"Country ".$loc->country_name." ".
	"Language ".$lang->name_in_local." ".
	"Umlaut äöü";
};

1;