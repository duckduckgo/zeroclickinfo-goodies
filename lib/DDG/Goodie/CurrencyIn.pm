package DDG::Goodie::CurrencyIn;
# ABSTRACT: Return currency type(s) in given country

# TODO: At the moment it return value only if user inputs the whole country name...
#     ...if user types "Salvador" instead of "El Salvador" then no results...
# TODO: think about how often currency in countries changes? 
#     Parser (for Wikipedia) is included in share directory...

# In some countries there are more than one currency.
# For that reason values in hash are stored as arrays. (loaded from .txt as comma separated values )
# Example: %countries( "Zimbabwe"=>["A","B"], "Slovakia"=>["A"], ... )"

# Working examples for queries:
# What currency do I need in Egypt ?
# What currency will I need for Zimbabwe
# What is the currency used in Slovakia
# currency in Russia
# What type of currency do I need for Russia?

use DDG::Goodie;

zci is_cached => 1;
zci answer_type => "currency_in";

triggers any => 'currency';	# User typed currency...

# Countries are lowercased but input from user, too ... so those always match...
# ...country is capitalized on output...

my %countries = share('currency.txt')->slurp;	

sub clearCountryName {		
	my $txt = shift;
	$txt =~ s/^\?$|\?$//g;	# Query may end with "?". If so take it away.
	$txt =~ s/^\s+|\s+$//g;	# Trim spaces before and after the country name
	return $txt
}

handle remainder => sub {

	if (/^.*(?:in|of|for)\s(.*?)$/) {
		$country = lc($1);				# Country name is result of previous regexp - make it lowercased
		$country = clearCountryName($country); 		# Clear country name - white spaces, question mark..
		$country = $country . "\n"; 			# At the moment share() function parsing names with "\n" so match user input..
		
		if (exists $countries{$country}){
			my $string_currency = $countries{$country};	# Load currencies as string (one line from .txt)
			my @currencies =  split(',', $string_currency);	# Split currencies into array
			$country =~ s/\n//g;				# Get rid of the end of the line character
			
			my $count = $#currencies + 1;			# Get number of currencies
			my $result = "";				# Store text result
			my $html = "";					# Store html result
			my $output_country = $country;			# Pass country name to the output_country
			$output_country =~ s/\b(\w)/\U$1/g; 		# so it can by capitalized			
			if ($count == 1) {				# In number of currencies == 1
				$result .= "The currency in $output_country is the ";
				$html .= "The currency in $output_country is the ";
			} else {
				$result .= "Currencies in $output_country are: \n";
				$html .= "Currencies in $output_country are:<br />";
			}
			
			# Append result with all currencies
			foreach $currency (@currencies){
                chomp($currency);
                $result .= $currency;
				$html .= "$currency<br />";
			}
			
			return $result, html=>$html			
		}		
	}

    return;
};

1;

