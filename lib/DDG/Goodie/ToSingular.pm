package DDG::Goodie::ToSingular;
# ABSTRACT: Convert a word from plural to singular

use DDG::Goodie;
use Lingua::EN::PluralToSingular qw(is_plural to_singular);

primary_example_queries 'sheep singular', 'shoal single';
description 'Converts a plural form of an English word to singular';
name 'To Singular';
topics 'gaming', 'entertainment';
category 'language';
attribution github => ['https://github.com/NabaSadiaSiddiqui', 'NabaSadiaSiddiqui'];

triggers startend => 'singular', 'single';

handle remainder => sub {
	return "Singular form of $_ is " . to_singular($_) if is_plural($_);
	return;
};

1;
