package DDG::Goodie::MolarMass;

# ABSTRACT: Write an abstract here

use strict;
use DDG::Goodie;
use List::Util qw(first);
use List::Util qw[min max];
use List::Util qw(any);
use YAML::XS 'LoadFile';
sub say { print @_, "\n" }
zci answer_type => 'molar_mass';
zci is_cached => 1;

my @elements = @{ LoadFile(share('elements.yml')) };
my @symbols = map { lc @$_[3] } @elements;
use Data::Dumper;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers startend => 'molar mass of', 'molar mass';

# Handle statement
handle remainder => sub {
    my $compound = $_;

    # Guard against no remainder
    return unless $compound;

    # Generate hash based on input
    my @result = parseParens($compound);
    
    # Calculate mass based on hash
    my $mass = calculateMass(@result);
    
    # Rebuild string from hash with proper capitilization to ensure that the right molecule was calculated
    $compound = rebuildString(@result);
    
    # TODO: Figure out html output
    return "Molar mass of $compound is $mass g/mol.",
        structured_answer => {
            data => {
                title => $mass . ' g/mol',
                subtitle => "The molar mass of <strong>" . subInts($compound) . "</strong> is: <strong>$mass g/mol</strong>."
            },
            templates => {
                group => 'text'
            }
        };
};


#
# Takes a hash
# Returns the total molar mass of all elements in the hash
#

sub calculateMass{
    my(@result) = @_;
    my $sum = 0;
    
    foreach my $part (@result){
        unless(exists $part->{symbol}){
            my @elements = @{$part->{elements}};
            $sum += calculateMass(@elements) * $part->{number};
            next;
        }
        
        my $symbol = $part->{symbol};
        my $multiplier = $part->{number};
        my $element = first { lc $symbol eq lc $_->[3] } @elements;
        my $mass = $element->[1];
        $sum += $mass * $multiplier;
    }
    
    return $sum;
}


#
# Rebuilds query string based on hash
# Proper capitilization is used. This ensures that the right molecule was calculated
# 

sub rebuildString{
    my(@result) = @_;
    my $string = "";
    
    foreach my $part (@result){
        if(exists $part->{symbol}){
            $string .= ucfirst $part->{symbol} . ($part->{number} gt 1 ? $part->{number} : '');
            next;
        }
        my @elements = @{$part->{elements}};
        my $number = $part->{number};
        
        if($number ne 1){ $string .= "(" }
        $string .= join '', map { ucfirst $_->{symbol} } @elements;
        if($number ne 1){ $string .= ")$number" }
    }
    return $string;
}

sub getElement{
    my($element, $multiplier) = @_;
    $multiplier = $multiplier ? $multiplier : 1;
    my @result;
    if($element ~~ @symbols){
        my %element = (
            symbol => $element,
            number => $multiplier
        );
        push @result, \%element;
        return @result;
    }
    
    my $length = length($element);
    
    for (my $i = min($length - 1, 3); $i >= 1; $i--){
        unless(substr($element, 0, $i) ~~ @symbols){ next }
        
        my %result = (
            symbol => substr($element, 0, $i),
            number => 1
        );
        push @result, \%result;
        $element = substr($element, $i);
        if($element ne ''){
            push @result, getElement($element, $multiplier);
        }
        return @result;
    }
    return @result;
}

sub parseParens{
    my($compound) = @_;
    my @results;
    
    my @parts;
    
    my $i = 20;
    while($compound ne "" && $i-- > 0){
        my($element, $multiplier);
        my $count = 1;
        my @element;
        
        if(startsWith($compound, "(")){
            ($element, $count) = $compound =~ /\(([a-z0-9]*\(.*\)[a-z0-9]*|[a-z0-9]+?)\)(\d+)/gi;
            $compound = strReplace($compound, "($element)$count", "");
        }else{
            say $compound =~ /([a-z0-9]+)(\d*)/gi;
            ($element, $multiplier) = $compound =~ /([a-z]+)(\d*)/gi;
            $compound = strReplace($compound, "$element$multiplier", "");
        }

        if(index($element, '(') ne -1){
            @element = getElement($element, $multiplier);
        }else{
            @element = getElement($element, $multiplier);
        }

        if(scalar @element eq 1){
            push @results, @element;
            next;
        }
        my %part = (
            elements => \@element,
            number => $count ? $count : 1
        );
        push @results, \%part;
    }
    return @results;
}

sub subInts{
    my $compound = $_;
    $compound =~ s/(\d)/<sub>$1<\/sub>/gi;
    return $compound;
}

sub strReplace{
    my($string, $find, $replace) = @_;
    my $index = index($string, $find);
    $replace = $replace ? $replace : "";
    return substr($string, 0, $index) . $replace . substr($string, $index + length($find));
}

sub startsWith{
    my($string, $char) = @_;
    return substr($string, 0, 1) eq $char;
}

1;
