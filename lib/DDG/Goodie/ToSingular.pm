package DDG::Goodie::ToSingular;
# ABSTRACT: Convert a word from plural to singular

use DDG::Goodie;
use Lingua::EN::PluralToSingular qw(is_plural to_singular);

primary_example_queries 'sheep singular', 'shoal single';
description 'Converts a plural form of an English word to singular';
name 'To Singular';
topics 'everyday';
category 'language';
attribution github => ['https://github.com/NabaSadiaSiddiqui', 'NabaSadiaSiddiqui'];

triggers startend => 'singular form of', 'singlular of', 'singular form', 'plural to singular';

handle remainder => sub {
	if(split(/ /,$_) == 1 && is_plural($_)) {
		return "The singular form of $_ is " . to_singular($_);
	}
	return;
};

1;
