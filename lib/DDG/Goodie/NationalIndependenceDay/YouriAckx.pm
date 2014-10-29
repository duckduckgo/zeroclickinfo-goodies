package DDG::Goodie::NationalIndependenceDay::YouriAckx;
# ABSTRACT: Retrieve the Independence day of the given country

use DDG::Goodie;
use JSON qw( decode_json );
use Text::Autoformat;

zci answer_type => "national_independence_day";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "NationalIndependenceDay YouriAckx";
description "Retrieve the Independence day of the given country";
primary_example_queries "independence day belgium", "independence day cyprus";
secondary_example_queries "national independence day belgium";
category "dates";
topics "everyday";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/NationalIndependenceDay/YouriAckx/YouriAckx.pm";
attribution github => ["YouriAckx", "Youri Ackx"],
            twitter => "YouriAckx";

# Triggers
triggers any => "national independence day", "independence day";

# Grabbed from
# https://raw.githubusercontent.com/jarmokivekas/zeroclickinfo-goodies/national-independence/share/goodie/independence_day/independence_days.json
# Added -nth suffixes. Denormalized some country names ("Korea, South" -> "South Korea") 
my $json = '{
	"abkhazia":{ "date": "July 4th", "year": "1993"},
	"afghanistan":{ "date": "August 19th", "year": "1919"},
	"albania":{ "date": "November 28th", "year": "1912"},
	"algeria":{ "date": "July 5th", "year": "1962"},
	"angola":{ "date": "November 11th", "year": "1975"},
	"antigua and barbuda":{ "date": "November 1st", "year": "1981"},
	"argentina":{ "date": "July 9th", "year": "1816"},
	"armenia":{ "date": "May 28th", "year": "1918th"},
	"armenia":{ "date": "September 21st", "year": "1991"},
	"austria":{ "date": "October 26th", "year": "1955"},
	"azerbaijan":{ "date": "May 28th", "year": "1918th"},
	"azerbaijan":{ "date": "October 18th", "year": "1991"},
	"bahamas":{ "date": "July 10th", "year": "1973"},
	"bahrain":{ "date": "August 15th", "year": "1971"},
	"bangladesh":{ "date": "March 26th", "year": "1971"},
	"barbados":{ "date": "November 30th", "year": "1966"},
	"belarus":{ "date": "July 3rd", "year": "1944"},
	"belgium":{ "date": "July 21st", "year": "1831"},
	"belize":{ "date": "September 21st", "year": "1981"},
	"benin":{ "date": "August 1st", "year": "1960"},
	"bolivia":{ "date": "August 6th", "year": "1825"},
	"bosnia and herzegovina":{ "date": "March 1st", "year": "1992"},
	"botswana":{ "date": "September 30th", "year": "1966"},
	"brazil":{ "date": "September 7th", "year": "1822"},
	"brunei":{ "date": "January 1st", "year": "1984"},
	"bulgaria":{ "date": "September 22nd", "year": "1908"},
	"burkina faso":{ "date": "August 5th", "year": "1960"},
	"burma":{ "date": "January 4th", "year": "1948"},
	"burundi":{ "date": "July 1st", "year": "1962"},
	"cambodia":{ "date": "November 9th", "year": "1953"},
	"cameroon":{ "date": "January 1st", "year": "1960"},
	"canada":{ "date": "July 1st", "year": "1867"},
	"cape verde":{ "date": "July 5th", "year": "1975"},
	"central african republic":{ "date": "August 13th", "year": "1960"},
	"chad":{ "date": "August 11th", "year": "1960"},
	"chile":{ "date": "February 12th and September 18th", "year": "1810"},
	"colombia":{ "date": "July 20th and August 7th", "year": "1810"},
	"comoros":{ "date": "July 6th", "year": "1975"},
	"congo democratic republic":{ "date": "June 30th", "year": "1960"},
	"congo republic":{ "date": "August 15th", "year": "1960"},
	"costa rica":{ "date": "September 15th", "year": "1821"},
	"croatia":{ "date": "October 8th", "year": "1991"},
	"cuba":{ "date": "May 20th", "year": "1902"},
	"cyprus":{ "date": "October 1st", "year": "1960"},
	"czech republic":{ "date": "October 28th", "year": "1918th"},
	"czech republic":{ "date": "January 1st", "year": "1993"},
	"denmark":{ "date": "June 5th", "year": "1849"},
	"djibouti":{ "date": "June 27th", "year": "1977"},
	"dominica":{ "date": "November 3rd", "year": "1978"},
	"dominican republic":{ "date": "December 1st", "year": "1821"},
	"dominican republic":{ "date": "February 27th", "year": "1844"},
	"east timor":{ "date": "May 20thth", "year": "2002"},
	"ecuador":{ "date": "August 10", "year": "1809"},
	"ecuador":{ "date": "May 24th", "year": "1822"},
	"el salvador":{ "date": "September 15th", "year": "1821"},
	"equatorial guinea":{ "date": "October 12th", "year": "1968"},
	"eritrea":{ "date": "May 24th", "year": "1993"},
	"estonia":{ "date": "February 24th", "year": "1918th"},
	"estonia":{ "date": "August 20th", "year": "1991"},
	"fiji":{ "date": "October 10th", "year": "1970"},
	"finland":{ "date": "December 6th", "year": "1917"},
	"gabon":{ "date": "August 17th", "year": "1960"},
	"gambia, the":{ "date": "February 18th", "year": "1965"},
	"georgia":{ "date": "May 26th", "year": "1918th"},
	"georgia":{ "date": "April 9th", "year": "1991"},
	"ghana":{ "date": "March 6th", "year": "1957"},
	"greece":{ "date": "March 25", "year": "1821"},
	"grenada":{ "date": "February 7th", "year": "1974"},
	"guatemala":{ "date": "September 15th", "year": "1821"},
	"guinea":{ "date": "October 2nd", "year": "1958"},
	"guinea-bissau":{ "date": "September 24th", "year": "1973"},
	"guyana":{ "date": "May 26th", "year": "1966"},
	"haiti":{ "date": "January 1st", "year": "1804"},
	"honduras":{ "date": "September 15th", "year": "1821"},
	"hungary":{ "date": "August 20th", "year": "1000"},
	"iceland":{ "date": "December 1st", "year": "1918th"},
	"india":{ "date": "August 15th", "year": "1947"},
	"indonesia":{ "date": "August 17th", "year": "1945"},
	"iraq":{ "date": "October 3rd", "year": "1932"},
	"ireland":{ "date": "April 24", "year": "1916"},
	"israel":{ "date": "Iyar 5th", "year": "1948"},
	"ivory coast":{ "date": "August 7th", "year": "1960"},
	"jamaica":{ "date": "August 6th", "year": "1962"},
	"japan":{ "date": "February 11st", "year": "660 B.C."},
	"jordan":{ "date": "May 25th", "year": "1946"},
	"kazakhstan":{ "date": "December 16th", "year": "1991"},
	"kenya":{ "date": "December 12th", "year": "1963"},
	"north korea":{ "date": "September 9th", "year": "1948"},
	"south korea":{ "date": "August 15th", "year": "1945"},
	"kosovo":{ "date": "February 8th", "year": "2008"},
	"kuwait":{ "date": "February 25th", "year": "1961"},
	"kyrgyzstan":{ "date": "August 31st", "year": "1991"},
	"laos":{ "date": "October 22", "year": "1953"},
	"latvia":{ "date": "November 18th", "year": "1918th"},
	"latvia":{ "date": "May 4th", "year": "1990"},
	"lebanon":{ "date": "November 22th", "year": "1943"},
	"lesotho":{ "date": "October 4th", "year": "1966"},
	"liberia":{ "date": "July 26th", "year": "1847"},
	"libya":{ "date": "December 24th", "year": "1951"},
	"lithuania":{ "date": "March 11th", "year": "1990"},
	"lithuania":{ "date": "February 16th", "year": "1918"},
	"macedonia, republic of":{ "date": "September 8th", "year": "1991"},
	"madagascar":{ "date": "June 26th", "year": "1960"},
	"malawi":{ "date": "July 6th", "year": "1964"},
	"malaysia":{ "date": "August 31st", "year": "1957"},
	"malaysia":{ "date": "September 16th", "year": "1963"},
	"maldives":{ "date": "July 26th", "year": "1965"},
	"mali":{ "date": "September 22th", "year": "1960"},
	"malta":{ "date": "September 21st", "year": "1964"},
	"mauritius":{ "date": "March 12th", "year": "1968"},
	"mexico":{ "date": "September 16th", "year": "1810"},
	"moldova":{ "date": "August 27th", "year": "1991"},
	"mongolia":{ "date": "December 29th", "year": "1911"},
	"montenegro":{ "date": "May 21st", "year": "2006"},
	"morocco":{ "date": "November 18th", "year": "1956"},
	"mozambique":{ "date": "June 25th", "year": "1975"},
	"nagorno-karabakh":{ "date": "September 2nd", "year": "1991"},
	"namibia":{ "date": "March 21st", "year": "1990"},
	"nauru":{ "date": "January 31st", "year": "1968"},
	"netherlands":{ "date": "May 5th", "year": "1945"},
	"nicaragua":{ "date": "September 15th", "year": "1821"},
	"niger":{ "date": "August 3rd", "year": "1960"},
	"nigeria":{ "date": "October 1st", "year": "1960"},
	"northern cyprus":{ "date": "September 2nd", "year": "1983"},
	"norway":{ "date": "May 17th", "year": "1814"},
	"pakistan":{ "date": "August 14th", "year": "1947"},
	"panama":{ "date": "November 28th", "year": "1821"},
	"panama":{ "date": "November 3rd", "year": "1903"},
	"papua new guinea":{ "date": "September 16th", "year": "1975"},
	"paraguay":{ "date": "May 15th", "year": "1811"},
	"peru":{ "date": "July 28th", "year": "1821"},
	"philippines":{ "date": "June 12th", "year": "1898"},
	"poland":{ "date": "November 11th", "year": "1918th"},
	"portugal":{ "date": "December 1st", "year": "1640"},
	"qatar":{ "date": "December 18th", "year": "1971"},
	"rhodesia":{ "date": "November 11th", "year": "1965"},
	"romania":{ "date": "May 10th", "year": "1866"},
	"rwanda":{ "date": "July 1st", "year": "1962"},
	"saint kitts and nevis":{ "date": "September 19th", "year": "1983"},
	"saint lucia":{ "date": "February 22th", "year": "1979"},
	"saint vincent and":{ "date": "October 27th", "year": "1979"},
	"samoa":{ "date": "January 1st", "year": "th1962"},
	"são tomé and príncipe":{ "date": "July 12", "year": "1975"},
	"senegal":{ "date": "April 4th", "year": "1960"},
	"serbia":{ "date": "February 15th", "year": "1804"},
	"seychelles":{ "date": "June 29th", "year": "1976"},
	"sierra leone":{ "date": "April 27th", "year": "1961"},
	"singapore":{ "date": "August 9th", "year": "1965"},
	"slovakia":{ "date": "July 17th", "year": "1992"},
	"slovenia":{ "date": "December 26th and June 25th", "year": "1990"},
	"solomon islands":{ "date": "July 7th", "year": "1978"},
	"somalia":{ "date": "July 1st", "year": "1960"},
	"south africa":{ "date": "December 11th", "year": "1931"},
	"south sudan":{ "date": "July 9", "year": "2011"},
	"sri lanka":{ "date": "February 4th", "year": "1948"},
	"sudan":{ "date": "January 1st", "year": "1956"},
	"suriname":{ "date": "November 25th", "year": "1975"},
	"swaziland":{ "date": "September 6th", "year": "1968"},
	"sweden":{ "date": "June 6th", "year": "1523"},
	"switzerland":{ "date": "August 1st", "year": "1291"},
	"syria":{ "date": "April 17th", "year": "1946"},
	"tajikistan":{ "date": "September 9th", "year": "1991"},
	"tanzania":{ "date": "December 9th", "year": "1961"},
	"togo":{ "date": "April 27th", "year": "1960"},
	"tibet":{ "date": "February 13th", "year": "1913"},
	"tonga":{ "date": "June 4th", "year": "1970"},
	"trinidad and":{ "date": "August 31st", "year": "1962"},
	"tunisia":{ "date": "March 20th", "year": "1956"},
	"turkmenistan":{ "date": "October 27th", "year": "1991"},
	"ukraine":{ "date": "August 24th", "year": "1991"},
	"ukraine":{ "date": "January 22nd", "year": "1919"},
	"united arab emirates":{ "date": "December 2nd", "year": "1971"},
	"united states of america":{ "date": "July 4th", "year": "1776"},
	"uruguay":{ "date": "August 25th", "year": "1825"},
	"uzbekistan":{ "date": "September 1st", "year": "1991"},
	"vanuatu":{ "date": "July 30th", "year": "1980"},
	"venezuela":{ "date": "July 5th", "year": "1811"},
	"vietnam":{ "date": "September 2nd", "year": "1945"},
	"yemen":{ "date": "November 30th", "year": "1967"},
	"zambia":{ "date": "October 24th", "year": "1964"},
	"zimbabwe":{ "date": "April 18th", "year": "1980"}
}';

my $independence = decode_json($json);

# Handle statement
handle remainder => sub {

	# optional - regex guard
	# return unless qr/^\w+/;

	return unless $_;                       # Guard against "no answer"
    return unless $independence->{$_};      # Country not found

    my $country = autoformat $_, { case => 'title' };
    chomp $country;                         # Weird: autoformat introduces
    chomp $country;                         # two newlines. Remove them
    
    print $_;
    print $country;
    print $_;
    
    my $prolog = 'Independence day of ' . $country;
    my $date_str = $independence->{$_}{'date'} . ', ' . $independence->{$_}{'year'};
    
    my $html = '<div class="text--primary">' . $prolog . '</div>';
    $html .= '<div class="text--secondary">' . $date_str . '</div>';
    
    my $text = $prolog . "\n" . $date_str;
    
    return $text, html => $html, heading => "National independence day";
};

1;