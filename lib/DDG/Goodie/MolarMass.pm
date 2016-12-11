package DDG::Goodie::MolarMass;

# ABSTRACT: Write an abstract here

use strict;
use DDG::Goodie;
use List::Util qw(first);
use YAML::XS 'LoadFile';

zci answer_type => 'molar_mass';
zci is_cached => 1;

my @elements = @{ LoadFile(share('elements.yml')) };
my @symbols = map { lc @$_[3] } @elements;
use Data::Dumper;
print "\n";

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers startend => 'molar mass of', 'molar mass';

# Handle statement
handle remainder => sub {

    my $compound = $_;

    # Optional - Guard against no remainder
    # I.E. the query is only 'triggerWord' or 'trigger phrase'
    #
    # return unless $remainder;

    # Optional - Regular expression guard
    # Use this approach to ensure the remainder matches a pattern
    # I.E. it only contains letters, or numbers, or contains certain words
    #
    # return unless qr/^\w+|\d{5}$/;
    # 

    my $mass = parseParens($compound, 1);
#     my $compoundString = get_mass_from_compound($compound, 1);
#     my $molarMass = parse_compound_string($compoundString);


    return "Molar Mass of $compound is $mass.",
        structured_answer => {
            input     => [$compound],
            operation => 'Molar Mass of Compound',
            result    => $mass
        };
};

sub getMassOfElement{
    my($symbol) = @_;
    my $element = first { lc $symbol eq lc $_->[3] } @elements;
    return $element->[1];
}

sub getElement{
    my($element, $multiplier) = @_;
    
    if($element ~~ @symbols){
        return getMassOfElement($element) * $multiplier;
    }
    
    my $length = length($element);
    
    if($length gt 3 && substr($element, 0, 3) ~~ @symbols){
        return getMassOfElement(substr($element, 0, 3)) + getElement(substr($element, 3), $multiplier);
    }
    
    if($length gt 2 && substr($element, 0, 2) ~~ @symbols){
        return getMassOfElement(substr($element, 0, 2)) + getElement(substr($element, 2), $multiplier);
    }
    
    if($length gt 1 && substr($element, 0, 1) ~~ @symbols){
        return getMassOfElement(substr($element, 0, 1)) + getElement(substr($element, 1), $multiplier);
    }
    
    if($length eq 1){
        print "Could not find $element\n";
    }
    
}

sub calculateMass{
    my($compound) = @_;
    my $sum = 0;
    my @matches;
    push @matches, [$1, $2] while $compound =~ /([a-z]+)(\d*)/gi;
    
    foreach my $match (@matches){
        my $element = @$match[0];
        my $multiplier = @$match[1] ? @$match[1] : 1;
        $sum += getElement($element, $multiplier);
    }
    
    return $sum;
}

sub parseParens{
    my($compound, $multiplier) = @_;
    my $sum = 0;
    my @matches;
    push @matches, [$1, $2] while $compound =~ /\(([a-z0-9]*\(.*\)[a-z0-9]*|[a-z0-9]+?)\)(\d+)/gi;
    
    $compound =~ s/\(([a-z0-9]*\(.*\)[a-z0-9]*|[a-z0-9]+?)\)(\d+)/_/g;
    
    foreach my $match (@matches){
        $sum += parseParens(@$match[0], @$match[1]);
    }
    
    $sum += calculateMass($_) for split('_', $compound);
    
    return $sum * $multiplier;
}

1;
