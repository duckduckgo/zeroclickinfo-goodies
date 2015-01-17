package DDG::Goodie::SalesTax;
use DDG::Goodie;
use Locale::SubCountry;
use YAML::XS qw(Load);
 
triggers startend => 'sales tax for', 'sales tax', 'what is the sales tax for', 'what is sales tax for';
 
zci answer_type => "sales_tax";
zci is_cached   => 1;
 
primary_example_queries 'Sales tax for pennsylvania', 'Sales tax pennsylvania';
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
 
    my $query = $_;
 
    #If our query is Washington DC convert it to District of Columbia
    if($query =~ m/\b(washington\sdc|d\.c)\b/i) {
        $query = "District of Columbia"
    }
 
    #Return the full name of the state as determined by SubCountry
    my $state = $US->full_name($US->code($query));
    return unless $state;
 
    #Lookup the $state in $salestax YML data
    my $tax = $salestax->{$state};
    return unless $tax;
 
    #If $tax is 0% then the state does not levy sales tax
    if ($tax eq "0%") {$tax = $state." does not levy a sales tax.";}
    return $state . " sales tax: $tax",
      structured_answer => {
        input     => [$state],
        operation => 'Sales tax for',
        result    => $tax
      };
};
1;
