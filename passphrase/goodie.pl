my @words = [];
open(IN, '<passphrase/goodie.txt');
while (my $line = <IN>) {
  chomp($line);
  push(@words, $line);
}
close(IN);

if ($type ne 'E' && $q_check_lc =~ m/^passphrase ([1-9]+)(?: word| words|)$/i) {
  my $word_count = int($1);
  for (my $count = 0; $count < $word_count; $count++) {
    my $word = splice @words, (int(rand @words)), 1;
    $answer_results .= "$word ";
  }
  # Remove the trailing space
  chop $answer_results;
  $answer_results = qq(random passphrase: $answer_results);
  $answer_type = 'passphrase';
  $is_memcached = 0;
  $type = 'E';
}
