package DDG::Goodie::CurrencyIn;
# ABSTRACT: Return currency type(s) in given country

# TODO: At the moment it return value only if user inputs the whole country name...
#     ...if user types "Salvador" instead of "El Salvador" then no results...
# TODO: Search pattern is "currency" and "in/of/for" words but when user types
#     query with two words like "what type {of} currency do I need {for} Russia" then 
#     word "of" is found first and it doesn't continue to "for" in front of Russia..
#     maybe it should start looking for words after word "currency" but 
#     how can I get position of "currency" when it is not passed into subrutine?..
# TODO: think about how often currency in countries changes - what then? 
#     Parse text (parser already build) from Wikipedia and manually copy paste?

# In some countries there are more than one currency
# For that reason values in hash are stored as arrays. Example:
# %countries( "Zimbabwe"=>["A","B"], "Slovakia"=>["A"], ... )"

# Working examples:
# What currency do I need in Egypt ?
# What currency will I need for Zimbabwe
# What is the currency used in Slovakia
# currency in Russia

use DDG::Goodie;

triggers any => 'currency';			# User typed currency...

# Hash with all countries and currencies is now included in file
# There is already build parser (in Python) to generate it from Wikipedia
# Countries are lowercased but input from user, too ... so those always match...
# ...country is capitalized on output...
my %currencies = (
	"abkhazia"=>["Russian ruble (RUB)"],
	"afghanistan"=>["Afghan afghani (AFN)"],
	"akrotiri and dhekelia"=>["Euro (EUR)"],
	"albania"=>["Albanian lek (ALL)"],
	"alderney"=>["Alderney pound","British pound (GBP)","Guernsey pound"],
	"algeria"=>["Algerian dinar (DZD)"],
	"andorra"=>["Euro (EUR)"],
	"angola"=>["Angolan kwanza (AOA)"],
	"anguilla"=>["East Caribbean dollar (XCD)"],
	"antigua and barbuda"=>["East Caribbean dollar (XCD)"],
	"argentina"=>["Argentine peso (ARS)"],
	"armenia"=>["Armenian dram (AMD)"],
	"aruba"=>["Aruban florin (AWG)"],
	"ascension island"=>["Ascension pound","Saint Helena pound (SHP)"],
	"australia"=>["Australian dollar (AUD)"],
	"austria"=>["Euro (EUR)"],
	"azerbaijan"=>["Azerbaijani manat (AZN)"],
	"bahamas"=>["Bahamian dollar (BSD)"], # name on Wikipedia is like: "Bahamas, The"..?.
	"bahrain"=>["Bahraini dinar (BHD)"],
	"bangladesh"=>["Bangladeshi taka (BDT)"],
	"barbados"=>["Barbadian dollar (BBD)"],
	"belarus"=>["Belarusian ruble (BYR)"],
	"belgium"=>["Euro (EUR)"],
	"belize"=>["Belize dollar (BZD)"],
	"benin"=>["West African CFA franc (XOF)"],
	"bermuda"=>["Bermudian dollar (BMD)"],
	"bhutan"=>["Bhutanese ngultrum (BTN)","Indian rupee (INR)"],
	"bolivia"=>["Bolivian boliviano (BOB)"],
	"bonaire"=>["United States dollar (USD)"],
	"bosnia and herzegovina"=>["Bosnia and Herzegovina convertible mark (BAM)"],
	"botswana"=>["Botswana pula (BWP)"],
	"brazil"=>["Brazilian real (BRL)"],
	"british indian ocean territory"=>["United States dollar (USD)"],
	"british virgin islands"=>["British Virgin Islands dollar","United States dollar (USD)"],
	"brunei"=>["Brunei dollar (BND)","Singapore dollar (SGD)"],
	"bulgaria"=>["Bulgarian lev (BGN)"],
	"burkina faso"=>["West African CFA franc (XOF)"],
	"burma"=>["Burmese kyat (MMK)"],
	"burundi"=>["Burundian franc (BIF)"],
	"cambodia"=>["Cambodian riel (KHR)"],
	"cameroon"=>["Central African CFA franc (XAF)"],
	"canada"=>["Canadian dollar (CAD)"],
	"cape verde"=>["Cape Verdean escudo (CVE)"],
	"cayman islands"=>["Cayman Islands dollar (KYD)"],
	"central african republic"=>["Central African CFA franc (XAF)"],
	"chad"=>["Central African CFA franc (XAF)"],
	"chile"=>["Chilean peso (CLP)"],
	"china, people's republic of"=>["Chinese yuan (CNY)"],
	"cocos (keeling) islands"=>["Australian dollar (AUD)","Cocos (Keeling) Islands dollar"],
	"colombia"=>["Colombian peso (COP)"],
	"comoros"=>["Comorian franc (KMF)"],
	"congo, democratic republic of the"=>["Congolese franc (CDF)"],
	"congo, republic of the"=>["Central African CFA franc (XAF)"],
	"cook islands"=>["New Zealand dollar (NZD)","Cook Islands dollar"],
	"costa rica"=>["Costa Rican colón (CRC)"],
	"croatia"=>["Croatian kuna (HRK)"],
	"cuba"=>["Cuban convertible peso (CUC)","Cuban peso (CUP)"],
	"curaçao"=>["Netherlands Antillean guilder (ANG)"],
	"cyprus"=>["Euro (EUR)"],
	"czech republic"=>["Czech koruna (CZK)"],
	"côte d'ivoire"=>["West African CFA franc (XOF)"],
	"denmark"=>["Danish krone (DKK)"],
	"djibouti"=>["Djiboutian franc (DJF)"],
	"dominica"=>["East Caribbean dollar (XCD)"],
	"dominican republic"=>["Dominican peso (DOP)"],
	"east timor"=>["United States dollar (USD)"],
	"ecuador"=>["United States dollar (USD)"],
	"egypt"=>["Egyptian pound (EGP)"],
	"el salvador"=>["Salvadoran colón (SVC)","United States dollar (USD)"],
	"equatorial guinea"=>["Central African CFA franc (XAF)"],
	"eritrea"=>["Eritrean nakfa (ERN)"],
	"estonia"=>["Euro (EUR)"],
	"ethiopia"=>["Ethiopian birr (ETB)"],
	"falkland islands"=>["Falkland Islands pound (FKP)"],
	"faroe islands"=>["Danish krone (DKK)","Faroese króna"],
	"fiji"=>["Fijian dollar (FJD)"],
	"finland"=>["Euro (EUR)"],
	"france"=>["Euro (EUR)"],
	"french polynesia"=>["CFP franc (XPF)"],
	"gabon"=>["Central African CFA franc (XAF)"],
	"gambia, the"=>["Gambian dalasi (GMD)"],
	"georgia"=>["Georgian lari (GEL)"],
	"germany"=>["Euro (EUR)"],
	"ghana"=>["Ghana cedi (GHS)"],
	"gibraltar"=>["Gibraltar pound (GIP)"],
	"greece"=>["Euro (EUR)"],
	"grenada"=>["East Caribbean dollar (XCD)"],
	"guatemala"=>["Guatemalan quetzal (GTQ)"],
	"guernsey"=>["British pound (GBP)","Guernsey pound"],
	"guinea"=>["Guinean franc (GNF)"],
	"guinea-bissau"=>["West African CFA franc (XOF)"],
	"guyana"=>["Guyanese dollar (GYD)"],
	"haiti"=>["Haitian gourde (HTG)"],
	"honduras"=>["Honduran lempira (HNL)"],
	"hong kong"=>["Hong Kong dollar (HKD)"],
	"hungary"=>["Hungarian forint (HUF)"],
	"iceland"=>["Icelandic króna (ISK)"],
	"india"=>["Indian rupee (INR)"],
	"indonesia"=>["Indonesian rupiah (IDR)"],
	"iran"=>["Iranian rial (IRR)"],
	"iraq"=>["Iraqi dinar (IQD)"],
	"ireland"=>["Euro (EUR)"],
	"isle of man"=>["British pound (GBP)","Manx pound"],
	"israel"=>["Israeli new shekel (ILS)"],
	"italy"=>["Euro (EUR)"],
	"jamaica"=>["Jamaican dollar (JMD)"],
	"japan"=>["Japanese yen (JPY)"],
	"jersey"=>["British pound (GBP)","Jersey pound"],
	"jordan"=>["Jordanian dinar (JOD)"],
	"kazakhstan"=>["Kazakhstani tenge (KZT)"],
	"kenya"=>["Kenyan shilling (KES)"],
	"kiribati"=>["Australian dollar (AUD)","Kiribati dollar"],
	"korea, north"=>["North Korean won (KPW)"],
	"korea, south"=>["South Korean won (KRW)"],
	"kosovo"=>["Euro (EUR)"],
	"kuwait"=>["Kuwaiti dinar (KWD)"],
	"kyrgyzstan"=>["Kyrgyzstani som (KGS)"],
	"laos"=>["Lao kip (LAK)"],
	"latvia"=>["Latvian lats (LVL)"],
	"lebanon"=>["Lebanese pound (LBP)"],
	"lesotho"=>["Lesotho loti (LSL)","South African rand (ZAR)"],
	"liberia"=>["Liberian dollar (LRD)"],
	"libya"=>["Libyan dinar (LYD)"],
	"liechtenstein"=>["Swiss franc (CHF)"],
	"lithuania"=>["Lithuanian litas (LTL)"],
	"luxembourg"=>["Euro (EUR)"],
	"macau"=>["Macanese pataca (MOP)"],
	"macedonia, republic of"=>["Macedonian denar (MKD)"],
	"madagascar"=>["Malagasy ariary (MGA)"],
	"malawi"=>["Malawian kwacha (MWK)"],
	"malaysia"=>["Malaysian ringgit (MYR)"],
	"maldives"=>["Maldivian rufiyaa (MVR)"],
	"mali"=>["West African CFA franc (XOF)"],
	"malta"=>["Euro (EUR)"],
	"marshall islands"=>["United States dollar (USD)"],
	"mauritania"=>["Mauritanian ouguiya (MRO)"],
	"mauritius"=>["Mauritian rupee (MUR)"],
	"mexico"=>["Mexican peso (MXN)"],
	"micronesia"=>["Micronesian dollar","United States dollar (USD)"],
	"moldova"=>["Moldovan leu (MDL)"],
	"monaco"=>["Euro (EUR)"],
	"mongolia"=>["Mongolian tögrög (MNT)"],
	"montenegro"=>["Euro (EUR)"],
	"montserrat"=>["East Caribbean dollar (XCD)"],
	"morocco"=>["Moroccan dirham (MAD)"],
	"mozambique"=>["Mozambican metical (MZN)"],
	"nagorno-karabakh republic"=>["Armenian dram (AMD)","Nagorno-Karabakh dram"],
	"namibia"=>["Namibian dollar (NAD)","South African rand (ZAR)"],
	"nauru"=>["Australian dollar (AUD)","Nauruan dollar"],
	"nepal"=>["Nepalese rupee (NPR)"],
	"netherlands"=>["Euro (EUR)"],
	"new caledonia"=>["CFP franc (XPF)"],
	"new zealand"=>["New Zealand dollar (NZD)"],
	"nicaragua"=>["Nicaraguan córdoba (NIO)"],
	"niger"=>["West African CFA franc (XOF)"],
	"nigeria"=>["Nigerian naira (NGN)"],
	"niue"=>["New Zealand dollar (NZD)","Niuean dollar"],
	"northern cyprus"=>["Turkish lira (TRY)"],
	"norway"=>["Norwegian krone (NOK)"],
	"oman"=>["Omani rial (OMR)"],
	"pakistan"=>["Pakistani rupee (PKR)"],
	"palau"=>["Palauan dollar","United States dollar (USD)"],
	"palestine"=>["Israeli new shekel (ILS)","Jordanian dinar (JOD)"],
	"panama"=>["Panamanian balboa (PAB)","United States dollar (USD)"],
	"papua new guinea"=>["Papua New Guinean kina (PGK)"],
	"paraguay"=>["Paraguayan guaraní (PYG)"],
	"peru"=>["Peruvian nuevo sol (PEN)"],
	"philippines"=>["Philippine peso (PHP)"],
	"pitcairn islands"=>["New Zealand dollar (NZD)","Pitcairn Islands dollar"],
	"poland"=>["Polish złoty (PLN)"],
	"portugal"=>["Euro (EUR)"],
	"qatar"=>["Qatari riyal (QAR)"],
	"romania"=>["Romanian leu (RON)"],
	"russia"=>["Russian ruble (RUB)"],
	"rwanda"=>["Rwandan franc (RWF)"],
	"saba"=>["United States dollar (USD)"],
	"sahrawi republic"=>["Algerian dinar (DZD)","Mauritanian ouguiya (MRO)","Moroccan dirham (MAD)","Sahrawi peseta"],
	"saint helena"=>["Saint Helena pound (SHP)"],
	"saint kitts and nevis"=>["East Caribbean dollar (XCD)"],
	"saint lucia"=>["East Caribbean dollar (XCD)"],
	"saint vincent and the grenadines"=>["East Caribbean dollar (XCD)"],
	"samoa"=>["Samoan tālā (WST)"],
	"san marino"=>["Euro (EUR)"],
	"saudi arabia"=>["Saudi riyal (SAR)"],
	"senegal"=>["West African CFA franc (XOF)"],
	"serbia"=>["Serbian dinar (RSD)"],
	"seychelles"=>["Seychellois rupee (SCR)"],
	"sierra leone"=>["Sierra Leonean leone (SLL)"],
	"singapore"=>["Brunei dollar (BND)","Singapore dollar (SGD)"],
	"sint eustatius"=>["United States dollar (USD)"],
	"sint maarten"=>["Netherlands Antillean guilder (ANG)"],
	"slovakia"=>["Euro (EUR)"],
	"slovenia"=>["Euro (EUR)"],
	"solomon islands"=>["Solomon Islands dollar (SBD)"],
	"somalia"=>["Somali shilling (SOS)"],
	"somaliland"=>["Somaliland shilling"],
	"south africa"=>["South African rand (ZAR)"],
	"south georgia and the south sandwich islands"=>["British pound (GBP)","South Georgia and the South Sandwich Islands pound"],
	"south ossetia"=>["Russian ruble (RUB)"],
	"south sudan"=>["South Sudanese pound (SSP)"],
	"spain"=>["Euro (EUR)"],
	"sri lanka"=>["Sri Lankan rupee (LKR)"],
	"sudan"=>["Sudanese pound (SDG)"],
	"suriname"=>["Surinamese dollar (SRD)"],
	"swaziland"=>["Swazi lilangeni (SZL)"],
	"sweden"=>["Swedish krona (SEK)"],
	"switzerland"=>["Swiss franc (CHF)"],
	"syria"=>["Syrian pound (SYP)"],
	"são tomé and príncipe"=>["São Tomé and Príncipe dobra (STD)"],
	"taiwan (republic of china)"=>["New Taiwan dollar (TWD)"],
	"tajikistan"=>["Tajikistani somoni (TJS)"],
	"tanzania"=>["Tanzanian shilling (TZS)"],
	"thailand"=>["Thai baht (THB)"],
	"togo"=>["West African CFA franc (XOF)"],
	"tonga"=>["Tongan paʻanga (TOP)"],
	"transnistria"=>["Transnistrian ruble"],
	"trinidad and tobago"=>["Trinidad and Tobago dollar (TTD)"],
	"tristan da cunha"=>["Saint Helena pound (SHP)","Tristan da Cunha pound"],
	"tunisia"=>["Tunisian dinar (TND)"],
	"turkey"=>["Turkish lira (TRY)"],
	"turkmenistan"=>["Turkmenistani manat (TMT)"],
	"turks and caicos islands"=>["United States dollar (USD)"],
	"tuvalu"=>["Australian dollar (AUD)","Tuvaluan dollar"],
	"uganda"=>["Ugandan shilling (UGX)"],
	"ukraine"=>["Ukrainian hryvnia (UAH)"],
	"united arab emirates"=>["United Arab Emirates dirham (AED)"],
	"united kingdom"=>["British pound (GBP)"],
	"united states"=>["United States dollar (USD)"],
	"uruguay"=>["Uruguayan peso (UYU)"],
	"uzbekistan"=>["Uzbekistani som (UZS)"],
	"vanuatu"=>["Vanuatu vatu (VUV)"],
	"vatican city"=>["Euro (EUR)"],
	"venezuela"=>["Venezuelan bolívar (VEF)"],
	"vietnam"=>["Vietnamese đồng (VND)"],
	"wallis and futuna"=>["CFP franc (XPF)"],
	"yemen"=>["Yemeni rial (YER)"],
	"zambia"=>["Zambian kwacha (ZMK)"],
	"zimbabwe"=>["Botswana pula (BWP)","British pound (GBP)","Euro (EUR)","South African rand (ZAR)","United States dollar (USD)","Zimbabwean dollar (ZWL)"],
);	

sub clearCountryName {	# Query may end with "?". If so take it away.
	my $txt = shift;
	my $last = substr($txt, length($txt)-1, 1);
	if ($last eq "?") {
		$txt = substr($txt,0, length($txt) -1);
	}
	$txt =~ s/^\s+|\s+$//g;	# Trim spaces before and after the country name
	return $txt
}

handle remainder => sub {
	#print $_;
	if ($_ =~ /(in\s*.*|of\s*.*|for\s*.*)/) {
		
		# My not very effective way of looking for position of the country name
		my $position = 0;
		if ($_ =~ /(in\s*.*)/) {
			$position = index($_, "in ") + 3;
		} elsif ($_ =~ /(of\s*.*)/) {
			$position = index($_, "of ") + 3;
		} elsif ($_ =~ /(for\s*.*)/) {
			$position = index($_, "for ") + 4;
		} else {
			return;
		}	
		
		$country = lc(substr($_, $position));		# Get lowercased country from position calculated above
		
		$country = clearCountryName($country);
		print $country;
		
		if (exists $currencies{$country}){
			my $count = $#{$currencies{$country}} + 1;
			my $result = "";
			my $html = "";	
			my $output_country = $country;			# Pass it to the output_country
			$output_country =~ s/\b(\w)/\U$1/g; 	# so it can by capitalized
			if ($count == 1) {
				$result .= "Currency in $output_country is ";
				$html .= "Currency in $output_country is ";
			} else {
				$result .= "Currencies in $output_country are: \n";
				$html .= "Currencies in $output_country are:<br />";
			}
			
			# Append result with all currencies
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

