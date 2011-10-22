 
# Calculates the Golden Ratio A:B given either A or B.

if (!$type && $q =~ m/^golden ratio (?:(?:(\?)\s*:\s*(\d+(?:\.\d+)?))|(?:(\d+(?:\.\d+)?)\s*:\s*(\?)))$/i) {
  my $golden_ratio = (1 + sqrt(5)) / 2;
  my $result = 0; 
   
  if ($1 && $1 eq "?") {
    # ? : x
    $result = $2 / $golden_ratio;
    $answer_results = "$result : $2";
  } elsif ($4 && $4 eq "?") {
    # x : ? 
    $result = $3 * $golden_ratio; 
    $answer_results = "$3 : $result";
  } 

  if ($answer_results) {
      $answer_results = qq(Golden ratio: $answer_results);
      $answer_type = "golden_ratio";
  }
} 

