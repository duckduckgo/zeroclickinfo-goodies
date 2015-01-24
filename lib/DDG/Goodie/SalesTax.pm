package DDG::Goodie::SalesTax;
#ABSTRACT: Returns the sales tax for any state (not including territories) in the United States. 
use DDG::Goodie;
use Locale::SubCountry;
use YAML::XS qw(Load);

triggers any => 'sales tax for', 'sales tax', 'sales tax in';
 
zci answer_type => "sales_tax";
zci is_cached   => 1;

primary_example_queries 'Sales tax for pennsylvania', 'Sales tax pa';
secondary_example_queries 'what is sales tax for mississippi';
description 'Returns the sales tax of the specified state or territory in the United States';
name 'Sales Tax';
topics 'special_interest', 'geography', 'travel';
category 'random';
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/SalesTax.pm";
source "https://en.wikipedia.org/wiki/Sales_taxes_in_the_United_States";
attribution github => ['https://github.com/javathunderman', 'Thomas Denizou'];

#Create US SubCountry object
my $US = new Locale::SubCountry("US");

#Load states.yml
#country-aliases file
my $salestax = Load(scalar share('states.yml')->slurp);            

handle remainder => sub {
    my ($query,$state,$tax); #Define vars
    s/^what is (the)?//g; # strip common words
    $query = $_;

    # Washington D.C is a district and is not supported by the SubCountry package.
    if($query =~ m/\b(washington\s(dc|d\.c))\b/i) {
        $state = "Washington D.C"
    } else {
        # $US->full_name returns the full state name based on the ISO3166 code 
        $state = $US->full_name($query); # Check for state using ISO code (PA)
        if($state eq "unknown") {
            $state = $US->full_name($US->code($query)); # If state is "unknown" search for code using full state name (Pennsylvania)
        }
    }

    return unless $state;
    $tax = $salestax->{$state}; #Lookup the $state in $salestax YML data
    return unless $tax;
 
    #If $tax is 0% then the state does not levy sales tax
    if ($tax eq "0%") {$tax = $state." does not levy a sales tax.";}
    return $state . " sales tax: $tax",
      structured_answer => {
        input     => [$state],
        operation => 'Sales Tax',
        result    => $tax
      };
};
1;