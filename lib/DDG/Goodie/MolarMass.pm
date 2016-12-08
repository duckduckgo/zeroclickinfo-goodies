package DDG::Goodie::MolarMass;

# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if you are new
# to instant answer development

use strict;
use DDG::Goodie;
use List::Util qw(first);
use YAML::XS 'LoadFile';

zci answer_type => 'molar_mass';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

my @elements = @{ LoadFile(share('elements.yml')) };

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
    # 
    # 

my $compoundString = get_mass_from_compound($compound, "1");
my $molarMass = parse_compound_string($compoundString);



       return "Molar Mass of $compound is $molarMass.",
        structured_answer => {
            input     => [$compound],
            operation => 'Molar Mass of Compound',
            result    => $molarMass
        };
};



sub get_mass_from_compound
{
    my($compound, $asdf) = @_;
    my @matches = ($compound =~ m/[A-Z][a-z]?\d*|\((?:[^()]*(?:\(.*\))?[^()]*)+\)\d+/g);
    my $molarString = "";
    my $trailingNum = $asdf;

    foreach my $x (@matches)
    {
        my ($one, $two) = get_trailing_num($x);

        if ($x !~ /\(|\)/g)
        {
            $molarString .= $two * $trailingNum;
            $molarString .= $one .= ',';
        }
        else
        {
            #if there are parantheses we need to unpack them.
            if (substr($x, 0, 1) eq '(')
            {
                #deletes parentheses and grabs the substring within those parantheses
                $x = substr($x, 1, rindex($x, ')'));
            }

            $molarString .= get_mass_from_compound($x, $two);
        }
    }

    return $molarString;
}


sub get_trailing_num
{
    my $compound = shift;
    #this regex checks the string for the format of 'asdf1234' and divides the
    #characters from the digits.
    if ($compound =~ /(\D+)(\d+)$/g)
    {
        #$1 holds the compound name, #2 holds the number trailing.
        return ($1, $2);
    }
    else
    {
        #since there is no trailing number, there is an understood 1, this
        #returns as such.
        return ($compound, 1);
    }
}


sub parse_compound_string
{
    my $compoundString = shift;
    my $weight;
    my $compoundWeight = 0;
    my @values = split(',', $compoundString);

    foreach my $x (@values)
    {
        if ($x =~ /(\d+)(\D+)$/g)
        {
            #$1 holds the coefficient, #2 holds the compound.
            #return ($1, $2);
            #print "$1\n$2\n";
            
            my $match = first { lc $_->[3] eq lc $2 } @elements or return;

            my ( $atomic_number, $atomic_mass, $element_name, $element_symbol, $element_type ) = @{$match};
            
#                 $weight = $chemical_elements{$2}{weight};
                $compoundWeight += $atomic_mass * $1;
                # print "$weight\n";
            
        }

        # print "$x\n";
    }

    return $compoundWeight;
}




1;
