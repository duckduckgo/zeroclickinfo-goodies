my @verbs;
my @nouns;
my @adverbs;
my @adj;

my $push_arr = \@nouns;
open(IN, '<sentence/goodie.txt');

while (my $line = <IN>) {
  chomp($line);
  if ($line eq "adj:") {
    $push_arr = \@adj;
    next;
  }
  elsif ($line eq "verbs:") {
    $push_arr = \@verbs;
    next;
  }
  elsif ($line eq "adverbs:") {
    $push_arr = \@adverbs;
    next;
  }
  push(@$push_arr, $line);
}
close(IN);

# count (plural) + adjective + plural noun + verb + adverb

if ($type ne 'E' && $q_check_lc =~ m/^(?:random |)sentence$/i) {
  
  my $count = int(rand(32)) + 2;
  my $adj = splice @adj, (int(rand @adj)), 1;
  my $noun = splice @nouns, (int(rand @nouns)), 1;
  my $verb = splice @verbs, (int(rand @verbs)), 1;
  my $adverb = splice @adverbs, (int(rand @adverbs)), 1;

  $answer_results = "$count $adj $noun $verb $adverb";
  $answer_type = 'sentence';
  $is_memcached = 0;
  $type = 'E';
}
