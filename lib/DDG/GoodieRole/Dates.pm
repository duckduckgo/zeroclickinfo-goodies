package DDG::GoodieRole::Dates;
# ABSTRACT: A role to allow Goodies to recognize and work with dates in different notations.

use strict;
use warnings;

use Moo::Role;

use DDG::GoodieRole::Dates::Parser;

my $parser = DDG::GoodieRole::Dates::Parser->new();

# Accessors for useful regexes
sub full_year_regex {
    return date_format_to_regex('%Y');
}
sub full_month_regex {
    return date_format_to_regex('%B');
}
sub short_month_regex {
    return date_format_to_regex('%B');
}
sub full_day_of_week_regex {
    return date_format_to_regex('%A');
}
sub short_day_of_week_regex {
    return date_format_to_regex('%a');
}
sub time_24h_regex {
    return date_format_to_regex('%T');
}
sub time_12h_regex {
    return date_format_to_regex('%r');
}

sub is_valid_year {
	my ($year) = @_;
	return ($year =~ /^[0-9]{1,4}$/)
		&& (1*$year > 0)
		&& (1*$year < 10000);
}


1;
