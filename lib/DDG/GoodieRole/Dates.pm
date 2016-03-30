package DDG::GoodieRole::Dates;
# ABSTRACT: A role to allow Goodies to recognize and work with dates in different notations.

use strict;
use warnings;

use Moo::Role;

use DDG::GoodieRole::Dates::Parser;

my $parser = DDG::GoodieRole::Dates::Parser->new();

my $formatted_datestring = $parser->formatted_datestring;
my $descriptive_datestring = $parser->descriptive_datestring;

# my $date_parser = date_parser();
# $date_parser->parse_datestring_to_date(...);
sub date_parser {
    return DDG::GoodieRole::Dates::Parser->new(@_);
}

# Accessors for matching regexes
# These matches are for "in the right format"/"looks about right"
#  not "are valid dates"; expects normalised whitespace
sub datestring_regex {
    return qr#(?:$formatted_datestring|$descriptive_datestring)#i;
}
sub formatted_datestring_regex {
    return $formatted_datestring;
}
sub descriptive_datestring_regex {
    return $descriptive_datestring;
}

# Accessors for useful regexes
sub full_year_regex {
    return $parser->date_format_to_regex('%Y');
}
sub full_month_regex {
    return $parser->date_format_to_regex('%B');
}
sub short_month_regex {
    return $parser->date_format_to_regex('%B');
}
sub full_day_of_week_regex {
    return $parser->date_format_to_regex('%A');
}
sub short_day_of_week_regex {
    return $parser->date_format_to_regex('%a');
}
sub time_24h_regex {
    return $parser->date_format_to_regex('%T');
}
sub time_12h_regex {
    return $parser->date_format_to_regex('%r');
}

sub is_valid_year {
	my ($year) = @_;
	return ($year =~ /^[0-9]{1,4}$/)
		&& (1*$year > 0)
		&& (1*$year < 10000);
}


1;
