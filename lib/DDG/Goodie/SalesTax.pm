package DDG::Goodie::SalesTax;


use DDG::Goodie;
use Locale::Country;

zci answer_type => "sales_tax";
zci is_cached   => 1;

name        "SalesTax";
description "Matches states to sales tax percentages in the US.";
source      "https://en.wikipedia.org/wiki/Sales_taxes_in_the_United_States";
category    "geography";
topics      "travel", "geography";

primary_example_queries   "sales tax for Pennsylvania";


attribution github  => ["AJDev77", "AJ"],
            twitter => ["Emposoft",     "Emposoft"];
attribution github  => ["javathunderman", "Thomas Denizou"]
            
;
triggers any => 'sales tax for';



my %numbers    = (two   => 2, three => 3);
my $connectors = qr/of|for/;
my $counts     = join('|', values %numbers, keys %numbers);

handle remainder => sub {
    my $input = $_;
    
    $input =~ s/(?<count>$counts)\s*letters?|(?<num>number|numeric(?:al)?)//ig;
    
    my $count = $+{'count'} || '';   
    my $expr = ($count) ? 'alpha-' . ($numbers{$count} || $count) : ($+{'num'}) ? 'numeric' : 'alpha-2';
    $input =~ s/^\s*$connectors?\s+|\s+$//ig;        

    return unless $input;

    my @answer = result($input, $expr);

    
    return if @answer < 20;
    
   
    };
    

sub result {
    my ($input, $sw) = @_;
    my $result;
    
    
        return ($result, 'salestax')
      
    
}

1;