package DDG::Goodie::BloodDonor;
# ABSTRACT: Returns available donors for a blood type

use DDG::Goodie;

use strict;
use warnings;

triggers startend =>    'donor compatibility', 'donor', 'donors for', 
                        'blood donor', 'blood donors for', 'blood donor for',
                        'blood type', 'blood compatibility', 'compatibility', 'blood donor compatibility';

zci answer_type => "blood_donor";

primary_example_queries 'donor O+';
secondary_example_queries 'donor AB+';
description 'Donor types for a given blood type';
name 'BloodDonor';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/BloodDonor.pm';
category 'special';
topics 'everyday';
attribution github => ['https://github.com/faraday', 'faraday'];

my %typeMap = (
    'A' => 'A,O',
    'O' => 'O',
    'AB' => 'AB,A,B,O',
    'B' => 'B,O',
);

sub apply_css($)
{
    my ($html) = @_;
    my $css = scalar share('style.css')->slurp;
    return "<style type='text/css'>$css</style>\n$html";
}

sub table_data {
    my ($label, $value) = @_;
    return "<tr><td class='text--secondary'>$label</td><td class='text--primary'>$value</td></tr>";
}

handle remainder => sub {
    if ($_ =~ /^(O|A|B|AB)(\-|\+)$/i) {
        my $type = uc $1;
        my $rh = $2;

        my @idealResults = ();
        my @criticalResults = ();

        return unless defined $typeMap{$type};
      
        # ideally same Rh
        foreach our $donorType (split(",", $typeMap{$type})) {
            push(@idealResults, $donorType . $rh);
            if($rh eq '+') {
                # only when access to same Rh is impossible
                push(@criticalResults, $donorType . '-');
            }
        }

        my $output = '';
        my $html = "<table class='blooddonor'>";
        
        my $idealStr = join(' or ', @idealResults);
        my $criticalStr = join(' or ', @criticalResults);
        
        $output .= "Ideal donor: " . uc($_) . "\n";
        $output .= "Other donors: " . $idealStr . "\n";
        $html .= table_data("Ideal donor:", uc($_));
        $html .= table_data("Other donors:", $idealStr);
        
        if($rh eq '+') {
            $output .= "Only if no Rh(+) found: " . $criticalStr . "\n";
            $html .= table_data("<i>Only if</i> no Rh(+) found:", $criticalStr);
        }
        
        $html .= '</table>';
        return $output, html => apply_css($html), heading => "Donors for blood type ".uc($_);
    }
    return;
};
1;