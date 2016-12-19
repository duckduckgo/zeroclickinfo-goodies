package DDG::Goodie::MolarMass;

# ABSTRACT: Write an abstract here

use strict;
use DDG::Goodie;
use List::Util qw(first);
use List::Util qw[min max];
use List::Util qw(any);
use YAML::XS 'LoadFile';
zci answer_type => 'molar_mass';
zci is_cached => 1;

my @elements = @{ LoadFile(share('elements.yml')) };
my @symbols = map { lc @$_[3] } @elements;

use Data::Dumper;

triggers query_lc => qr/(?:what is the |)(molar|atomic) (mass|weight) (?:of|)/;

# Handle statement
handle query_lc => sub {
    my $compound = $_;
    
    # Parse input
    $compound =~ s/((?:what is the |)(molar|atomic) (mass|weight) (?:of|)| )//g;
    
    print "$compound\n";
    
    # Return if input does not contain any letters
    return unless $compound =~ /[a-z]/;

    # Generate hash based on input
    my @result = parseParens($compound);
    
    # Simplifies the object removing unnecesary brakets
    simplify(@result);
    
    # Calculate mass based on hash
    my $mass = calculateMass(@result);
    
    # Guard against invalid input
    return if $mass eq 0;
    
    # Rebuild string from hash with proper capitilization to ensure that the right molecule was calculated
    $compound = rebuildString(@result);
    
    return "The molar mass of $compound is $mass g/mol.",
    html => "The molar mass of <strong>" . subInts($compound) . "</strong> is <strong>$mass g/mol</strong>.";
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
        $string .= rebuildString(@{$part->{elements}});
        if($number ne 1){ $string .= ")$number" }
    }
    return $string;
}


sub simplify{
    my(@result) = @_;
    
    for(my $i = 0; $i < @result; $i++){
        my $part = $result[$i];
        unless(exists $part->{elements}){ next; }
        unless(scalar @{$part->{elements}} eq 1){
            $result[$i]->{elements} = simplify(@{$part->{elements}});
            next;
        }
        
        my %part = (
            symbol => $part->{elements}[0]->{symbol},
            number => $part->{number} * $part->{elements}[0]->{number}
        );
        $result[$i] = \%part;
#         print Dumper \%part;
    }
    
#     print Dumper \@result;
    return \@result;
}

#
# Takes a string of letters and sorts it into element symbol prioritizing longer symbols. That way, the user can use parenthese or underscores to separate elements. 
#

sub getElement{
    my($element, $multiplier) = @_;
    $multiplier = $multiplier ? $multiplier : 1;
    
    my @result;
    
    # If whole string is already an element, return it
    if($element ~~ @symbols){
        my %element = (
            symbol => $element,
            number => $multiplier
        );
        push @result, \%element;
        return @result;
    }
    
    my $length = length($element);
    
    # Get first $i characters of string and see if that is an element
    for (my $i = min($length - 1, 3); $i >= 1; $i--){
        # If not an element, continue
        unless(substr($element, 0, $i) ~~ @symbols){ next }
        
        # Otherwise, push the result
        my %result = (
            symbol => substr($element, 0, $i),
            number => 1
        );
        push @result, \%result;
        
        # ... and run recursively for the rest of the string
        $element = substr($element, $i);
        if($element ne ''){
            push @result, getElement($element, $multiplier);
        }
        
        return @result;
    }
    
    # This *should* never happen
    return @result;
}

sub parseParens{
    my($compound) = @_;
    my @results;
    
    my @parts;
    
    my $i = 20;
    while($compound ne "" && $i-- > 0){
        my $element;
        my $multiplier = 1;
        my $count = 1;
        my @element;
        
        if(startsWith($compound, "(")){
            ($element, $count) = $compound =~ /\(([a-z0-9]*\(.*\)[a-z0-9]*|[a-z0-9]+?)\)(\d*)/gi;
            $compound = strReplace($compound, "($element)$count", "");
        }else{
            ($element, $multiplier) = $compound =~ /([a-z]+)(\d*)/gi;
            $compound = strReplace($compound, "$element$multiplier", "");
        }
        
        if(index($element, '(') ne -1){
            @element = parseParens($element);
#             print "Element: \n";
#             print Dumper @element;
        }else{
            @element = getElement($element, $multiplier);
        }
        
        my %part = (
            elements => \@element,
            number => $count ? $count : 1
        );
        
        push @results, \%part;
    }
#     print Dumper \@results;
    return @results;
}

sub subInts{
    my($string) = @_;
    print "$string\n";
    $string =~ s/(\d+)/<sub>$1<\/sub>/gi;
    return $string;
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
