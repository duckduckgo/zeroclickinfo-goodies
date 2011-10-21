
my %passphrase = ();
open(IN, '<passphrase/goodie.txt');
while (my $line = <IN>) {
    chomp($line);
    my @res = split(/ /, $line);
    $passphrase{$res[0]} = $res[1];
    
}
close(IN);


if ($type ne 'E' && $q_check_lc =~ m/^passphrase ([1-9]+)(?: word| words|)$/i) {

    for (my $count = 0; $count < int($1); $count++) {
	my $ref_num = '';
	for (my $num = 0; $num < 5; $num++) {
	    # alea iacta est!!!
	    $ref_num .= int(rand(6)) + 1;
	}

	$answer_results .= "$passphrase{$ref_num} ";
    }

    # Remove the trailing space
    chop $answer_results;
    $answer_results = qq(random passphrase: $answer_results);

    $answer_type = 'passphrase';
    $is_memcached = 0;
    $type = 'E';

}
