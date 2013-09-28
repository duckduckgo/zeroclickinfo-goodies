package DDG::Goodie::Loan;
# ABSTRACT: Calculate monthly payment and total interest payment for a conventional mortgage loan

use DDG::Goodie;
use Locale::Currency::Format;

triggers start => 'loan';

zci is_cached => 1;
zci answer_type => 'loan';

primary_example_queries 'loan $500000 at 4.5% with 20% down';
secondary_example_queries 
	'loan $500000 at 4.5% with 20% down 15 years',
	'loan $500000 4.5%',
	'loan $500000 4.5% 20% down 15 years';

description 'Calculate monthly payment and total interest for conventional mortgage';
name 'Loan';
category 'finance';
topics 'economy_and_finance';
attribution github  => [ 'https://github.com/mmattozzi', 'mmattozzi' ];

# Monthly payment calculation from http://en.wikipedia.org/wiki/Mortgage_calculator
sub loan_monthly_payment {
	my ($p, $r, $n) = @_;
	return ($r / (1 - (1 + $r)**(-1 * $n))) * $p;
}

# A map of country code to currency code, filled in below
my %country_to_currency;

# A map of currency symbol to currency code, filled in below
my %symbol_to_currency = ( );

# From the symbol used, guess the currency (this will override any location data that comes in with the user). 
# This is pretty imprecise. Assume USD if a $ is used. More assumptions can be added here later to priorize 
# currency guessing. Perhaps location data can be used to break ties. 
sub convert_symbol_to_currency {
	my $symbol = shift;
	if ($symbol eq "\$") {
		return "USD";
	} else {
		return $symbol_to_currency{$symbol};
	}
}

# Given the country code and currency formatting rules, the input can be made ready to convert
# to a useable number. Examples: 
# In USD: 400,000 => 400000
# In EUR: 400.000,00 => 400000.00
sub normalize_formatted_currency_string {
	my ($str, $currency_code) = @_;
	
	my $thousands_separator = thousands_separator($currency_code);
	my $decimal_separator = decimal_separator($currency_code);
	
	$str =~ s/\Q$thousands_separator//g;
	if ($decimal_separator ne ".") {
		$str =~ s/\Q$decimal_separator/\./g;
	}
	
	return $str;
}

handle remainder => sub {
	my $query = $_;
	
	# At a minimum, query should contain some amount of money and a percent interest rate
	if ($query =~ /^(\p{Currency_Symbol})?([\d\.,]+)\s(at\s)?(\d+.?\d*)%/) {
		my $symbol = $1;
		my $principal = $2;
		my $rate = $4;
		my $downpayment = 0;
		my $years = 30;

		# Apply localization, default to US if unknown
		my $currency_code = "USD";
		if (defined $symbol) {
			$currency_code = convert_symbol_to_currency($symbol);
		} elsif (defined $loc->country_code) {
			$currency_code = $country_to_currency{$loc->country_code} || $country_to_currency{"us"};
			$symbol = currency_symbol($currency_code);
		}

		# Given the country code and currency formatting rules, the input can be made ready to convert
		# to a useable number. 
		$principal = normalize_formatted_currency_string($principal, $currency_code);

		# Check if query contains downpayment information
		if ($query =~ /(\p{Currency_Symbol})?(\d+)(%)? down/) {
			my $downpayment_is_in_cash = ! (defined $3);
			my $downpayment_without_units = $2;
			if ($downpayment_is_in_cash) {
				# Downpayment expresses in an amount of currency
				$downpayment = normalize_formatted_currency_string($downpayment_without_units, $currency_code);
			} else {
				# Downpayment expressed as a percentage of principal
				$downpayment = $principal * .01 * $downpayment_without_units;
			}
		}

		# Check if query contains number of years for loan
		if ($query =~ /(\d+) years?/) {
			$years = $1;
		}

		my $loan_amount = $principal - $downpayment;
		my $monthly_payment = loan_monthly_payment($loan_amount, $rate / 12 * .01, $years * 12);
		my $total_interest = ($monthly_payment * 12 * $years) - $loan_amount;

		return "Monthly Payment is " . currency_format($currency_code, $monthly_payment, FMT_SYMBOL) . 
			" for $years years. Total interest paid is " . 
			currency_format($currency_code, $total_interest, FMT_SYMBOL); 
			
	}
	return;
};

# A map of 2 letter country code to 3 letter currency code. Copied from Locale::Object perl module 
# (http://search.cpan.org/~jrobinson/Locale-Object/) which carries some extra baggage with it, and 
# has also not been updated since 2007. If the mapping between any country and currency needs to be 
# changed, this is where to change it. 
%country_to_currency = (
	'ad' => 'EUR',
	'ae' => 'AED',
	'af' => 'AFA',
	'ag' => 'XCD',
	'ai' => 'XCD',
	'al' => 'ALL',
	'am' => 'AMD',
	'an' => 'ANG',
	'ao' => 'AOA',
	'aq' => '000',
	'ar' => 'ARS',
	'as' => 'USD',
	'at' => 'EUR',
	'au' => 'AUD',
	'aw' => 'AWG',
	'az' => 'AZM',
	'ba' => 'BAM',
	'bb' => 'BBD',
	'bd' => 'BDT',
	'be' => 'EUR',
	'bf' => 'XOF',
	'bg' => 'BGL',
	'bh' => 'BHD',
	'bi' => 'BIF',
	'bj' => 'XOF',
	'bm' => 'BMD',
	'bn' => 'BND',
	'bo' => 'BOB',
	'br' => 'BRL',
	'bs' => 'BSD',
	'bt' => 'BTN',
	'bv' => 'NOK',
	'bw' => 'BWP',
	'by' => 'BYR',
	'bz' => 'BZD',
	'ca' => 'CAD',
	'cc' => 'AUD',
	'cd' => 'CDF',
	'cf' => 'XAF',
	'cg' => 'XAF',
	'ch' => 'CHF',
	'ci' => 'XOF',
	'ck' => 'NZD',
	'cl' => 'CLP',
	'cm' => 'XAF',
	'cn' => 'CNY',
	'co' => 'COP',
	'cr' => 'CRC',
	'cu' => 'CUP',
	'cv' => 'CVE',
	'cx' => 'AUD',
	'cy' => 'CYP',
	'cz' => 'CZK',
	'de' => 'EUR',
	'dj' => 'DJF',
	'dk' => 'DKK',
	'dm' => 'XCD',
	'do' => 'DOP',
	'dz' => 'DZD',
	'ec' => 'ECS',
	'ee' => 'EEK',
	'eg' => 'EGP',
	'eh' => 'MAD',
	'er' => 'ERN',
	'es' => 'EUR',
	'et' => 'ETB',
	'fi' => 'EUR',
	'fj' => 'FJD',
	'fk' => 'FKP',
	'fm' => 'USD',
	'fo' => 'DKK',
	'fr' => 'EUR',
	'fx' => 'EUR',
	'ga' => 'XAF',
	'gb' => 'GBP',
	'gd' => 'XCD',
	'ge' => 'GEL',
	'gf' => 'EUR',
	'gh' => 'GHC',
	'gi' => 'GIP',
	'gl' => 'DKK',
	'gm' => 'GMD',
	'gn' => 'GNF',
	'gp' => 'EUR',
	'gq' => 'GQE',
	'gr' => 'EUR',
	'gs' => 'GBP',
	'gt' => 'GTQ',
	'gu' => 'USD',
	'gw' => 'XOF',
	'gy' => 'GYD',
	'hk' => 'HKD',
	'hm' => 'AUD',
	'hn' => 'HNL',
	'hr' => 'HRK',
	'ht' => 'HTG',
	'hu' => 'HUF',
	'id' => 'IDR',
	'ie' => 'EUR',
	'il' => 'ILS',
	'in' => 'INR',
	'io' => 'GBP',
	'iq' => 'IQD',
	'ir' => 'IRR',
	'is' => 'ISK',
	'it' => 'EUR',
	'jm' => 'JMD',
	'jo' => 'JOD',
	'jp' => 'JPY',
	'ke' => 'KES',
	'kg' => 'KGS',
	'kh' => 'KHR',
	'ki' => 'AUD',
	'km' => 'KMF',
	'kn' => 'XCD',
	'kp' => 'KPW',
	'kr' => 'KRW',
	'kw' => 'KWD',
	'ky' => 'KYD',
	'kz' => 'KZT',
	'la' => 'LAK',
	'lb' => 'LBP',
	'lc' => 'XCD',
	'li' => 'CHF',
	'lk' => 'LKR',
	'lr' => 'LRD',
	'ls' => 'LSL',
	'lt' => 'LTL',
	'lu' => 'EUR',
	'lv' => 'LVL',
	'ly' => 'LYD',
	'ma' => 'MAD',
	'mc' => 'EUR',
	'md' => 'MDL',
	'me' => 'YUM',
	'mg' => 'MGF',
	'mh' => 'USD',
	'mk' => 'MKD',
	'ml' => 'XOF',
	'mm' => 'MMK',
	'mn' => 'MNT',
	'mo' => 'MOP',
	'mp' => 'USD',
	'mq' => 'EUR',
	'mr' => 'MRO',
	'ms' => 'XCD',
	'mt' => 'MTL',
	'mu' => 'MUR',
	'mv' => 'MVR',
	'mw' => 'MWK',
	'mx' => 'MXN',
	'my' => 'MYR',
	'mz' => 'MZM',
	'na' => 'NAD',
	'nc' => 'XPF',
	'ne' => 'XOF',
	'nf' => 'AUD',
	'ng' => 'NGN',
	'ni' => 'NIO',
	'nl' => 'EUR',
	'no' => 'NOK',
	'np' => 'NPR',
	'nr' => 'AUD',
	'nu' => 'NZD',
	'nz' => 'NZD',
	'om' => 'OMR',
	'pa' => 'PAB',
	'pe' => 'PEN',
	'pf' => 'XPF',
	'pg' => 'PGK',
	'ph' => 'PHP',
	'pk' => 'PKR',
	'pl' => 'PLN',
	'pm' => 'EUR',
	'pn' => 'NZD',
	'pr' => 'USD',
	'ps' => 'ILS',
	'pt' => 'EUR',
	'pw' => 'USD',
	'py' => 'PYG',
	'qa' => 'QAR',
	're' => 'EUR',
	'ro' => 'ROL',
	'rs' => 'YUM',
	'ru' => 'RUB',
	'rw' => 'RWF',
	'sa' => 'SAR',
	'sb' => 'SBD',
	'sc' => 'SCR',
	'sd' => 'SDP',
	'se' => 'SEK',
	'sg' => 'SGD',
	'sh' => 'SHP',
	'si' => 'SIT',
	'sj' => 'NOK',
	'sk' => 'SKK',
	'sl' => 'SLL',
	'sm' => 'EUR',
	'sn' => 'XOF',
	'so' => 'SOS',
	'sr' => 'SRG',
	'st' => 'STD',
	'sv' => 'SVC',
	'sy' => 'SYP',
	'sz' => 'SZL',
	'tc' => 'USD',
	'td' => 'XAF',
	'tf' => 'EUR',
	'tg' => 'XOF',
	'th' => 'THB',
	'tj' => 'TJS',
	'tk' => 'NZD',
	'tl' => 'IDR',
	'tm' => 'TMM',
	'tn' => 'TND',
	'to' => 'TOP',
	'tr' => 'TRL',
	'tt' => 'TTD',
	'tv' => 'AUD',
	'tw' => 'TWD',
	'tz' => 'TZS',
	'ua' => 'UAH',
	'ug' => 'UGX',
	'um' => 'USD',
	'us' => 'USD',
	'uy' => 'UYU',
	'uz' => 'UZS',
	'va' => 'EUR',
	'vc' => 'XCD',
	've' => 'VEB',
	'vg' => 'USD',
	'vi' => 'USD',
	'vn' => 'VND',
	'vu' => 'VUV',
	'wf' => 'XPF',
	'ws' => 'WST',
	'ye' => 'YER',
	'yt' => 'EUR',
	'yu' => 'YUM',
	'za' => 'ZAR',
	'zm' => 'ZMK',
	'zr' => 'XAF',
	'zw' => 'ZWD');

# Build the mapping of symbol to currency name
foreach my $code (values %country_to_currency) {
	my $symbol_for_code = currency_symbol($code);
	if (defined $symbol_for_code) {
		$symbol_to_currency{$symbol_for_code} = $code;
	}
}

# Add in uppercase version of country code to be safe
my %uc_country_to_currency_map = ( );
while (my($k, $v) = each %country_to_currency) {
	$uc_country_to_currency_map{uc $k} = $v;
}

@country_to_currency{keys %uc_country_to_currency_map} = values %uc_country_to_currency_map;

1;
