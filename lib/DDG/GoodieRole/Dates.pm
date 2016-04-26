package DDG::GoodieRole::Dates;
# ABSTRACT: A role to allow Goodies to recognize and work with dates in different notations.

use strict;
use warnings;

use Moo::Role;

use DDG::GoodieRole::Dates::Parser;

# Takes either a locale, or the $lang variable and gives back a date
# parser. If no argument specified then it will attempt to use the current
# '$lang'.
sub date_parser {
    my ($lang_locale) = shift;
    my $locale = defined $lang_locale
        ? ref $lang_locale eq 'DDG::Language'
             ? $lang_locale->locale
             : $lang_locale
        : undef;
    return DDG::GoodieRole::Dates::Parser->new(
        locale => $locale,
        fallback_locale => 'en',
    );
}


sub is_valid_year {
	my ($year) = @_;
	return ($year =~ /^[0-9]{1,4}$/)
		&& (1*$year > 0)
		&& (1*$year < 10000);
}


1;
