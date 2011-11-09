# Calculates em or px when given the other.

if (!$type && $q =~ m/^em to px (?:(?:(\?)\s*:\s*(\d+(?:\.\d+)?))|(?:(\d+(?:\.\d+)?)\s*:\s*(\?)))$/i) {
  my $result = 0;

  if ($1 && $1 eq "?") {
    # ? : x
    $result = $2 / 16;
    $answer_results = "$result : $2";
  } elsif ($4 && $4 eq "?") {
    # x : ?
    $result = $3 * 16;
    $answer_results = "$3 : $result";
  }

  if ($answer_results) {
      $answer_results = qq(em to px: $answer_results);
      $answer_type = "em_to_px";
  }
}