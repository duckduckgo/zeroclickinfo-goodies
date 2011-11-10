# Calculates em or px when given the other.

#if (!$type && $q =~ m/^em to px (?:(?:(\?)\s*:\s*(\d+(?:\.\d+)?))|(?:(\d+(?:\.\d+)?)\s*:\s*(\?)))$/i) {
if (!$type && $q =~ m/^(\d+[.]\d*|\d*[.]\d+|\d+)\s*(em|px)\s+(in|to)\s+(em|px)$/i) {
  my $result = 0;

  if ($2 && $2 eq "px") {
    # ? px in em 
    $result = $1 / 16;
    $answer_results = "$result em in $1 px";
  } elsif ($2 && $2 eq "em") {
      # ? em in px
    $result = $1 * 16;
    $answer_results = "$result px in $1 em";
  }

  if ($answer_results) {
      $answer_results = qq($answer_results);
      $answer_type = "em_to_px";
  }
}