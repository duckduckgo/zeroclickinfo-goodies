package DDG::Goodie::Geometry;
# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

use DDG::Goodie;
use strict;


use YAML::XS 'LoadFile';
use Data::Dumper;

zci answer_type => 'geometry';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

triggers any => 'geometry', 'geometry of', 'geometry of a', 'formula', 'calc';

my @objectInfo = LoadFile(share('objectInfo.yml'));
my $formulas = LoadFile(share('formulas.yml'));

handle remainder => sub {

    my $remainder = lc($_);

    return unless $remainder;
    
    my %object = findObject($remainder);
    
    # If hash is undefined, means we dont have shape in YML
    if (!%object) { return; }
    
    # build data
    my $objectFormulas = $object{formulas};
    my @dataFormula = ();
   
    #print Dumper(${$formulas}{'area'});   
    # Fill dataFormula with values for handlebar to parse
    while(my($key, $value) = each %{$objectFormulas}) {
        my %objectInfo = (
            'name' => $key,
            'nameCaps' => uc($key),
            'color' => ${$formulas}{$key}{'color'},
            'symbol' => ${$formulas}{$key}{'symbol'},
            'html' => $value,
            
        );
        
        push(@dataFormula, \%objectInfo);
    }
    
    
    my $objectSVG = LoadFile(share('svg/' . $remainder . '.svg'));
    return "plain text response",
        structured_answer => {
            id => 'Geometry',
            name  => 'Geometry',
            data => {
                title    => ucfirst($object{'name'}),
                formulas => \@dataFormula,
                svg => $objectSVG,
            },

            templates => {
                group => "text",
                options => {
                    subtitle_content => 'DDH.geometry.subtitle'
                }
            }
        };
};

# Tries to find object in objectInfo
# Given: Object's Name
sub findObject {
    my($objectName) = @_;
    
    foreach my $object_ref (@objectInfo) {
        if ($object_ref->{'name'} eq $objectName) {
            # Dereference into hash for return
            return %$object_ref;
        }
    }
    
    return;
}
1;
