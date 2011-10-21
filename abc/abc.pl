#
# Choose between the values matched between 'or' in input
# Must be alphabetic values
#

# sample queries:
# this or that or none
# duckduckgo or google or bing or something

if ( $q_check =~ m/^\!?\s*[A-Za-z]+(\s+or\s+[A-Za-z]+)+\s*$/ ) {
    my @choices = split(/\s+or\s+/, $q_check);
    my $choice = int(rand(@choices));

    $answer_results = $choices[$choice];
    $answer_results .= ' (random)';
    $answer_type = 'rand';
}

1;