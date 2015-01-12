package DDG::Goodie::SalesTax;
use DDG::Goodie;

triggers startend => 'sales tax for', 'sales tax';

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
            
my %salestax = (
    "Alabama"   => "4%",
    "Alaska"   => "Alaska does not levy a sales tax.",
    "Arizona"   => "5.6%",
    "Arkansas"   => "6.5%",
    "California"   => "7.5%",
    "Colorado"   => "2.9%",
    "Connecticut"   => "6.35%",
    "Delaware"   => "Delaware does not levy a sales tax.",
    "District of Columbia"   => "5.75%",
    "Florida"   => "6%",
    "Georgia"   => "4%",
    "Guam"   => "4%",
    "Hawaii"   => "4%",
    "Idaho"   => "6%",
    "Illinois"   => "6.25%",
    "Indiana"   => "7%",
    "Iowa"   => "6%",
    "Kansas"   => "6.15%",
    "Kentucky"   => "6%",
    "Louisiana"   => "4%",
    "Maine"   => "5.5%",
    "Maryland"   => "6%",
    "Massachusetts"   => "6.25%",
    "Michigan"   => "6%",
    "Minnesota"   => "6.875%",
    "Mississippi"   => "7%",
    "Missouri"   => "4.225%",
    "Montana"   => "Montana does not levy a sales tax.",
    "Nebraska"   => "5.5%",
    "Nevada"   => "6.85%",
    "New Hampshire"   => "New Hampshire does not levy a sales tax.",
    "New Jersey"   => "7%",
    "New Mexico"   => "7%",
    "New York"   => "4%",
    "North Carolina"   => "4.75%",
    "North Dakota"   => "5%",
    "Ohio"   => "5.75%",
    "Oklahoma"   => "4.5%",
    "Oregon"   => "Oregon does not levy a sales tax.",
    "Pennsylvania"   => "6%",
    "Puerto Rico"   => "6%",
    "Rhode Island"   => "7%",
    "South Carolina"   => "6%",
    "South Dakota"   => "4%",
    "Tennessee"   => "7%",
    "Texas"   => "6.25%",
    "Utah"   => "5.95%",
    "Vermont"   => "6%",
    "Virginia"   => "5.3%",
    "Washington state"   => "6.5%",
    "West Virginia"   => "6%",
    "Wisconsin"   => "5%",
    "Wyoming"   => "4%"
);

handle remainder => sub {
    my $state = ucfirst lc $_;

    return unless $state;
    my $tax = $salestax{$state};
    return unless $tax;

    return $state . " sales tax: $tax",
      structured_answer => {
        input     => [$state],
        operation => 'Sales tax for',
        result    => $tax
      };
};

1;
