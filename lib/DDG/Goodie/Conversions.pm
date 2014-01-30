package DDG::Goodie::Conversions;
# ABSTRACT: convert between various weights and measures
#
# available conversion units       same as google
# conversion multiples             same as google
# if no preposition, doesn't work, same as google

# Ns.B.: funny spacing? Trying to avoid > 80 width lines
#        code clarity > unreadable regexen

# @todo: significant digits
# @todo: handle stuff like no preposition, 'factorfromUnit'
# @todo: handle multi-word $fromUnits ?

use DDG::Goodie;
use Scalar::Util qw(looks_like_number);

triggers start => 'convert';    # @todo: beef this up! (regex-ify?)

zci is_cached => 1;

# <metadata>
name 'Conversions';
description 'convert between various weights and measures';
category 'calculations';
topics 'computing', 'math';
primary_example_queries 'convert 5 oz to grams';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Conversions.pm';
attribution github  => ['https://github.com/elohmrow', '/bda'],
            email   => ['bradley@pvnp.us'];
# </metadata>

handle remainder => sub {
    return doConversion($_);
};

sub doConversion {
    my $args = shift;
    
    my @args = split(/\s+/, $args);
    # @args = [factor, fromUnits, preposition, toUnits]
    #   e.g.  '3 pounds to kilos'

    my @origArgs = @args;

    my $result = '';
    my $hasErrors = 0;

    my %errors = (
        'factor'    => 'ERROR :: Cannot convert [QQQQQ] :: NaN.',
        'units'     => 'ERROR :: Cannot convert [QQQQQ] :: Unknown units.',
    );
    
    my @required = qw/1 3/;     # 1 = fromUnits, 2 = toUnits

    # add new units for conversion here.
    # these are all based on 'metric ton'.  
    # known SI units and abbreviations / plurals / common uses:
    my @conversionFactors = (
            {
                'unit'          => 'metric ton',
                'multiple'      => '1',
                'abbreviations' => ['tonne', 'tonnes', 't', 'mt', 'te', 
                                    'metric'],
            },  # 'metric ton'
            { 
                'unit'          => 'kilogram',
                'multiple'      => '1000',
                'abbreviations' => ['kilo', 'kilos', 'kg', 'kgs', 'kilogramme', 
                                    'kilogrammes', 'kilogram', 'kilograms'],
            }, 
            {
                'unit'          => 'gram',
                'multiple'      => '1000000',
                'abbreviations' => ['gram', 'grams', 'g', 'gm', 'grammes', 
                                    'gramme'],
            },
            {
                'unit'          => 'milligram',
                'multiple'      => '1000000000',
                'abbreviations' => ['milligram', 'mg', 'mgs', 'milligrams'],
            },
            {
                'unit'          => 'microgram',
                'multiple'      => '1000000000000',
                'abbreviations' => ['microgram', 'micrograms', 'mcg', 'mcgs'],
            },
            {
                'unit'          => 'long ton',
                'multiple'      => '0.984207',
                'abbreviations' => ['long', 'weight', 'imperial'],
            },  # 'long ton', 'weight ton', 'imperial ton', 'long tons', 
                # 'weight tons', 'imperial tons' 
            {
                'unit'          => 'short ton', 
                'multiple'      => '1.10231',
                'abbreviations' => ['ton', 'tons', 'short'],
            },  # 'short ton', 'short tons'
            {
                'unit'          => 'stone',
                'multiple'      => '157.473',
                'abbreviations' => ['st', 'stone'],
            },
            {
                'unit'          => 'pound',
                'multiple'      => '2204.62',
                'abbreviations' => ['lb', 'lbs', 'pound', 'pounds', 'lbm', 
                                    'lbms'],
            },  # 'pound mass'
            {
                'unit'          => 'ounce',
                'multiple'      => '35274',
                'abbreviations' => ['ounce', 'ounces', 'oz', 'ozs'],
            },
    );
    #
    # ^ due to the way args come in only space-delimited, can't reliably 
    #   search on multi-word units like 'imperial ton'.  user could 
    #   issue a command to convert 'imperial troopers to ounces' - that would
    #   be difficult, and would be translated to 'imperial ton to ounces'
    #   
    # ^ for some units, plural = singular - listing them all out = clear
    #   es.g.: 'tes', 'gs', 'ts' don't mean anything
    #

    foreach my $required (@required) {
        my $found = 0;

        # convert user input into standard conversion factors:
        foreach my $conversionFactor (@conversionFactors) {
            if (lc($args[$required]) ~~ @{$conversionFactor->{'abbreviations'}})
            {
                $args[$required] = $conversionFactor->{'multiple'};

                $found = 1;
            } 
        }
        
        if (!$found) {
            $hasErrors = 1;

            #$result .= ($errors{'units'} =~ s/QQQQQ/$args[$required]/);
            $errors{'units'} =~ s/QQQQQ/$args[$required]/;
            $result .= $errors{'units'};
        }

        $errors{'units'} = 'ERROR :: Cannot convert [QQQQQ] :: Unknown units.';
    }

    # $args[0] must be a number:
    if ($hasErrors || !looks_like_number($args[0])) {
        if (!looks_like_number($args[0])) {
            # keeping errors in order:
            $errors{'factor'} =~ s/QQQQQ/$args[0]/;
            $result = ($errors{'factor'} . $result);
        }
            
        #$result =~ s/ERROR/\nERROR/g;
    }

    else {  # run the conversion:
        if ($args[1] > 1) {
            $result = (1 / $args[1]) * $args[3] * $args[0];
        }
        else {
            $result =      $args[1]  * $args[3] * $args[0];
        }
       
        if ($origArgs[1] =~/long|weight|imperial|metric|short/i) {
            $origArgs[1] .= ' ton';
        }

        if ($origArgs[3] =~/long|weight|imperial|metric|short/i) {
            $origArgs[3] .= ' ton';
        }

        # formatting:
        ($origArgs[0] > 1)     ? $origArgs[1] .= 's' 
                               : $origArgs[1]  = $origArgs[1]; 
        ($result > 1)          ? $origArgs[3] .= 's' 
                               : $origArgs[3]  = $origArgs[3];

        $origArgs[1] =~ s/ss$/s/;
        $origArgs[3] =~ s/ss$/s/;


        $result = "$origArgs[0] $origArgs[1] is $result $origArgs[3].";
    }

    #$result =~ s/^\n//;

    return $result;
}



1;
