package DDG::Goodie::CallingCodes;
# ABSTRACT: Matches country names to international calling codes

use DDG::Goodie;
use Locale::Country qw/country2code code2country/;
use Telephony::CountryDialingCodes;

zci answer_type => "calling_codes";
zci is_cached   => 1;

name        "CallingCodes";
description "Matches country names to international calling codes";
source      "https://en.wikipedia.org/wiki/List_of_country_calling_codes#Alphabetical_listing_by_country_or_region";
code_url    "https://github.com/duckduckgo/zeroclickinfo-spice/blob/master/lib/DDG/Goodie/CallingCodes.pm";
category    "geography";
topics      "travel", "geography";

primary_example_queries   "calling code 55", "dialing code brazil";
secondary_example_queries "dialing code +55", "country calling code 55";

attribution github  => ["kablamo",            "Eric Johnson"],
            web     => ["http://kablamo.org", "Eric Johnson"];

my @codewords   = qw(code codes);
my @descriptors = ('calling', 'dialing', 'dial-in', 'dial in');
my @extras      = qw(international country);

my @triggers;
foreach my $cw (@codewords) {
    foreach my $desc (@descriptors) {
        push @triggers, $desc . ' ' . $cw;
        foreach my $extra (@extras) {
            push @triggers, join(' ', $extra, $desc, $cw);
        }
    }
}

triggers any => @triggers;

Locale::Country::rename_country('ae' => 'the United Arab Emirates');
Locale::Country::rename_country('do' => 'the Dominican Republic');
Locale::Country::rename_country('gb' => 'the United Kingdom');
Locale::Country::rename_country('kr' => "the Republic of Korea");                     # South Korea
Locale::Country::rename_country('kp' => "the Democratic People's Republic of Korea"); # North Korea
Locale::Country::rename_country('ky' => 'the Cayman Islands');
Locale::Country::rename_country('mp' => 'the Northern Mariana Islands');
Locale::Country::rename_country('nl' => 'the Netherlands');
Locale::Country::rename_country('ph' => 'the Philippines');
Locale::Country::rename_country('ru' => 'the Russian Federation');
Locale::Country::rename_country('tw' => 'Taiwan');
Locale::Country::rename_country('us' => 'the United States');
Locale::Country::rename_country('va' => 'the Holy See (Vatican City State)');
Locale::Country::rename_country('vg' => 'the British Virgin Islands');
Locale::Country::rename_country('vi' => 'the US Virgin Islands');

# These are the only 2 countries which officially have 'The' in their name
# Source: http://www.bbc.co.uk/news/magazine-18233844
Locale::Country::rename_country('gm' => 'The Gambia');
Locale::Country::rename_country('bs' => 'The Bahamas');

Locale::Country::add_country_alias('Antigua and Barbuda'  => 'Antigua');
Locale::Country::add_country_alias('Antigua and Barbuda'  => 'Barbuda');
Locale::Country::add_country_alias('Russian Federation'   => 'Russia');
Locale::Country::add_country_alias('Trinidad and Tobago'  => 'Tobago');
Locale::Country::add_country_alias('Trinidad and Tobago'  => 'Trinidad');
Locale::Country::add_country_alias('Vatican City'         => 'Vatican');
Locale::Country::add_country_alias('Virgin Islands, U.S.' => 'US Virgin Islands');

# Source: http://www.bbc.co.uk/news/magazine-18233844
Locale::Country::add_country_alias('United States' => 'America');


# Easter eggs
Locale::Country::add_country_alias('Russian Federation' => 'Kremlin');
Locale::Country::add_country_alias('United States' => 'murica');
Locale::Country::add_country_alias('Canada' => 'Canadia');
Locale::Country::add_country_alias('Australia' => 'down under');

handle remainder => sub {
    my $query = shift;

    my ($dialing_code, @countries);

    my $in_number;
    if ($query =~ /^\+?(\d+)/) {
        $in_number = $1;
        # $query looks like a phone number. eg +65
        ($dialing_code, @countries) = number_to_country($in_number);
    } elsif ($query =~ /^\w+/) {
        # $query looks like a country name or country code. eg Brazil or Br
        ($dialing_code, @countries) = country_to_calling_code($query);
    }

    return unless $dialing_code && @countries && (defined $countries[0]);

    $dialing_code = '+' . $dialing_code;
    my $country_list = list2string(@countries);

    return $dialing_code . ' is the international calling code for ' . $country_list . '.',
      structured_answer => {
        input => [$in_number ? $dialing_code : $country_list],
        operation => 'International calling code',
        result    => ($in_number ? $country_list : $dialing_code),
      };
};

# Convert a list of country names to a single human readable English string.
sub list2string {
    my @countries = @_;
    my $string;

    $_ =~ s/^The /the / for @countries;

    if (scalar @countries == 1) {
        $string = $countries[0];
    }
    elsif (scalar @countries == 2) {
        $string = $countries[0] . " and " . $countries[1];
    }
    else {
        my $last = pop @countries;
        $string = join ', ', @countries;
        $string .= ", and " . $last;
    }

    return $string;
}

# Deduce the country from a number.
sub number_to_country {
    my $number = shift;

    my $telephony     = Telephony::CountryDialingCodes->new;
    my @country_codes = $telephony->country_codes($number);
    my $dialing_code  = $telephony->extract_dialing_code($number);
    my @countries     = map { code2country($_) } @country_codes;

    return ($dialing_code, @countries);
}

# Deduce the calling code from a country name or country code.
sub country_to_calling_code {
    my $country = shift;

    # clean up
    $country =~ s/^to\s+//;
    $country =~ s/^for\s+//;
    $country =~ s/^in\s+//;
    $country =~ s/^the\s+//;
    $country =~ s/\s+\+?\d+$//; # remove trailing phone code. for queries
                                # like 'calling code for brazil +55'

    my $country_code = country2code($country);

    # if we didn't find a country code, maybe $country is a country_code
    $country_code = $country unless $country_code;

    $country = code2country($country_code);

    my $telephony    = Telephony::CountryDialingCodes->new;
    my $dialing_code = $telephony->dialing_code($country_code);

    return ($dialing_code, $country);
}

1;
