package DDG::Goodie::CurrencyIn;
# ABSTRACT: Return currency type(s) in given country

# TODO: Maybe improve hash.txt or at least place it to share directory

# TODO: At the moment it return value only if user input the whole country name...
#     ...if user types "Czech" instead of "Czech republic" then no results...


# In some countries there are more than one currency
# For that reason values in hash are arrays. Example:
# %countries( "Zimbabwe", [], "Slovakia", [], ... )"
# Format in hash.txt is Country:Currency,Currency,... each on one line

use DDG::Goodie;

triggers start => 'currency';			# User typed currency...

handle remainder => sub {
	$start = substr($_, 0,2);
	if ($start eq "in") {				# ...but continue only if user typed "currency in." 
		$country = lc(substr($_, 3));	# Get country without "in " at the begining
		
		my %currencies;
		# Get currencies and countries from hash.txt
		open(IN, 'lib/DDG/Goodie/hash.txt') or die "$!";
		while(<IN>) {
		   chomp;
		   my($k,$v) = split(':');
		   @s = split(",",$v);
		   $k = lc($k);
		   $currencies{$k} =  [@s];
		}
		close IN;		
		
		if (exists $currencies{$country}){
			my $count = $#{$currencies{$country}} + 1;
			my $result = "";
			my $html = "";	
			my $output_country = $country;			# Pass it to the output
			$output_country =~ s/\b(\w)/\U$1/g; 	# so it can by capitalized
			if ($count == 1) {
				$result .= "Currency in $output_country is ";
				$html .= "Currency in $output_country is ";
			} else {
				$result .= "Currencies in $output_country are: \n";
				$html .= "Currencies in $output_country are:<br />";
			}
			
			# List all currencies
			for $i (0.. $#{$currencies{$country}}){
				$result .= "$currencies{$country}[$i] \n";
				$html .= "$currencies{$country}[$i] <br />";
			}
			
			zci is_cached => 1;
			zci answer_type => "currency_in";
			return $result, html=>$html
			
		}		
	}

    return;
};

1;

