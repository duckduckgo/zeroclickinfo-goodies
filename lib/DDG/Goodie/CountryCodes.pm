package DDG::Goodie::CountryCodes;

# ABSTRACT: Matches country names to ISO 3166 codes and vice versa

use strict;
use DDG::Goodie;
use Locale::Country qw/country2code code2country/;

zci answer_type => "country_codes";
zci is_cached   => 1;

triggers any => 'country code', 'iso code', 'iso 3166';

my %numbers    = (two   => 2, three => 3);
my $connectors = qr/of|for/;
my $counts     = join('|', values %numbers, keys %numbers);

handle remainder => sub {
    my $input = $_;
    # Strip and match descriptors.
    $input =~ s/(?<count>$counts)\s*letters?|(?<num>number|numeric(?:al)?)//ig;

    my $count = $+{'count'} || '';    # Get any code set indication if present e.g. 3, two
    my $expr = ($count) ? 'alpha-' . ($numbers{$count} || $count) : ($+{'num'}) ? 'numeric' : 'alpha-2';
    $input =~ s/^\s*$connectors?\s+|\s+$//ig;         # Trim remainder to get country.

    return unless $input;

    my @answer = result($input, $expr);

    # Return if user input was neither country or code
    return if @answer < 2;

    # Swap country and code, if user had entered code
    ($input, $answer[0]) = ($answer[0], $input) if $answer[1] eq 'code';

    return 'ISO 3166: '. ucfirst $input .' - '. $answer[0],
        structured_answer => {
            data => {
                title    => $answer[0],
                subtitle => "ISO 3166 Country code: " . ucfirst ($input)
            },
            templates => {
                group => "text"
            }
    };
};

sub result {
    my ($input, $sw) = @_;
    my $result;

    # Validate user input and return result accordingly, possible values country, code, or invalid
        ($result = country2code($input, $sw)) ? return ($result, 'country')
      : ($result = code2country($input, $sw)) ? return ($result, 'code')
      :                                         return -1;
}

1;
