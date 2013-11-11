package DDG::Goodie::BloodDonor;
# ABSTRACT: Returns available donors for a blood type

use DDG::Goodie;

triggers start => 'donor';
zci is_cached => 1;
zci answer_type => "blood_donor";

primary_example_queries 'donor 0+';
secondary_example_queries 'donor AB+';
description 'Return donor types for a given blood type';
name 'BloodDonor';
code_url 'http://github.com';
category 'special';
topics 'everyday';
attribution github => ['https://github.com/faraday', 'faraday'];

my %typeMap = ( "0" , "0",
              "A" , "A,0",
              "B" , "B,0",
              "AB", "AB,A,B,0"
            );

handle remainder => sub {
    if ($_ =~ /(0|A|B|AB)(\-|\+)/g) {
      my $type = $1;
      my $rh = $2;

      my @idealResults = ();
      my @criticalResults = ();

      # ideally same Rh
      foreach our $donorType (split(",",$typeMap{$type})) {
          push(@idealResults, $donorType . $rh);
          if($rh eq '+') {
            # only when access to same Rh is impossible
            push(@criticalResults, $donorType . '-');
          }
      }

      my $output = '';
      my $html = '<table>';
      my $idealStr = join(' or ', @idealResults);
      my $criticalStr = join(' or ', @criticalResults);
      $output .= "Ideal donor: " . $_ . "\n";
      $output .= "Other donors: " . $idealStr . "\n";
      $html .= '<tr><td>Ideal donor:&nbsp;&nbsp;&nbsp;</td><td>' . $_ . "</td></tr>";
      $html .= '<tr><td>Other donors:&nbsp;&nbsp;&nbsp;</td><td>' 
        . $idealStr . "</td></tr>";
      if($rh eq '+') {
        $output .= "Only if no Rh(+) found: " . $criticalStr . "\n";
        $html .= '<tr><td><b>Only if</b> no Rh(+) found:&nbsp;&nbsp;&nbsp;</td><td>' 
          . $criticalStr . "</td></tr>";
      }
      $html .= '</table>';
      return $output, html => $html, heading => "Donors for blood type $_";
    }

    return;
};
1;