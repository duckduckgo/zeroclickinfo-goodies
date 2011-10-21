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
        
    if ( my @duck = grep { $_ eq 'duckduckgo' or $_ eq 'duck' or $_ eq 'ddg' } @choices ) { 
        $answer_results = $duck[0].' (not random)';
        $answer_type = 'egg';
    }
    else {
        $answer_results = $choices[$choice];
        $answer_results .= ' (random)';
        $answer_type = 'rand';
    }
}
