package DDG::Goodie::EconomicIndicators;
# ABSTRACT: 
# Instant answer for economic indicators for different countries
# The indicators considered are
#   a) Gross Domestic Product
#   b) Annual Growth Rate
#   c) Per Capita Income
# All data used in this instant answer comes form World Bank(http://data.worldbank.org)

use DDG::Goodie;
use JSON;

zci answer_type => "economic_indicators";
zci is_cached   => 1;

name "Economic Indicators";
description "Gives information about economic indicators of a country( Gross Domestic Product, Per Capita Income, Growth Rate)";
primary_example_queries "gdp of india", "china per capita income","india growth rate";
category "finance";
topics "economy_and_finance";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/EconomicIndicators.pm";
attribution github => ["gauravtiwari5050", "Gaurav Tiwari"];


# Triggers
triggers any => "gdp", "gross domestic product","growth rate","per capita income";


# The specific urls for data sources are mentioned in file share/goodie/economic_indicators/data_sources.json
# The script share/goodie/economic_indicators/fetch_and_parse.sh downloads files from above mentioned sources
# and parses them to generate files gdp.json,per_capita_income.json,growth_rate.json which are being consumed here

my $gdp_data = share('gdp.json')->slurp;
$gdp_data = decode_json($gdp_data);

my $growth_rate_data = share('growth_rate.json')->slurp;
$growth_rate_data = decode_json($growth_rate_data);

my $per_capita_income_data = share('per_capita_income.json')->slurp;
$per_capita_income_data = decode_json($per_capita_income_data);

my $data_sources = share('data_sources.json')->slurp;
$data_sources = decode_json($data_sources);

# define aliases for some countries to improve hit rate
my $alias_lookup = share('country_aliases.json')->slurp;
$alias_lookup = decode_json($alias_lookup);



# Handle statement
handle query_clean => sub {
    my $data; #holds country level data
    my $data_source_id; #holds the data source id
    my $data_source; #holds the data source id

    #select the data_source based on the type of economic inicator requested in the query
    if (/gdp/ or /gross domestic product/) {
      $data = $gdp_data;
      $data_source_id = 'gdp'
    } elsif (/growth rate/) {
      $data = $growth_rate_data;
      $data_source_id = 'growth_rate'
    } elsif (/per capita income/){
      $data = $per_capita_income_data;
      $data_source_id = 'per_capita_income';
    }
    $data_source = $data_sources->{$data_source_id};
    return unless $data and $data_source_id and $data_source;
    
    # delete noise from query string
    s/(gdp|gross domestic product|growth rate|per capita income|what|is the|for|of)//g;
    # delete the whitespace left from query noise (spaces between words)
    s/^\s*|\s*$//g;
    # only the name of the country should be left in the string at this point
    my $country_key = $alias_lookup->{$_} || $_;
    
    # return if the string is not one of the countries
    return unless $data->{$country_key};
    
    # Format the country name properly for display
    my $country = $country_key;
    # Title Case The Country Name
    $country =~ s/(\w\S*)/\u\L$1/g;
    # lowercase the words 'of', 'the' and 'and'
    $country =~ s/\sThe\s/ the /;
    $country =~ s/\sOf\s/ of /;
    $country =~ s/\sAnd\s/ and /;

    # ouput string formatting
    my $prolog = "$data_source->{'display_name'} of " . $country . " ($data_source->{'relevant_year'}) ";
    
    my $data_str = $data->{$country_key};
    
    #if the requested indicator is Gross Domestic Product convert the answer to make it more readable
    if($data_source_id eq 'gdp'){
      if($data_str/1000000000000 > 1){
        $data_str = sprintf("%.3f Trillion USD",$data_str/1000000000000);
      } elsif($data_str/1000000000 > 1){
        $data_str = sprintf("%.3f Billion USD",$data_str/1000000000);
      } elsif($data_str/1000000 > 1){
        $data_str = sprintf("%.3f Million USD",$data_str/1000000);
      } else {
        $data_str = sprintf("%.3f USD",$data_str/1.0);
      }
    } elsif($data_source_id eq 'per_capita_income'){
        $data_str = sprintf("%.0f USD",$data_str/1.0);
    } elsif($data_source_id eq 'growth_rate'){
        $data_str = sprintf("%.2f %%",$data_str/1.0);
    } 

    # html formatted answer
    my $html = '<div class="zci--economic-indicators">';
    $html .= '<div class="text--primary">' . $data_str . '</div>';
    $html .= '<div class="text--secondary">' . $prolog . '</div>';
    $html .= '</div>';
    # plain text answer
    my $text = $prolog  . ' ' . $data_str;

    return $text, html => $html;


};

1;
