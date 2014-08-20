package DDG::Goodie::Average;
# ABSTRACT: take statistics for a list of numbers

use DDG::Goodie;

triggers startend => "avg", "average", "mean", "median", "root mean square";

zci is_cached => 1;
zci answer_type => "average";

primary_example_queries 'average 12, 45, 78, 1234';
secondary_example_queries 'avg 1,2,3', 'root mean square 1,2,3';
description 'take the average of a list of numbers';
name 'Average';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Average.pm';
category 'calculations';
topics 'math';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

my $css = share("style.css")->slurp();
sub append_css {
    my $html = shift;
    return "<style type='text/css'>$css</style>\n" . $html;
}

handle remainder => sub {

    #Remove leading/trailing text from list of numbers
    s/^[a-zA-Z\s]+//;
    s/\s+[a-zA-Z]+$//;

    #Ensure numbers are space-delimited
    s/[;,\s{}\[\]\(\)]+/ /g;

    #Return unless only left with space-delimited list of numbers
    return unless /^\s*(?:\d+(?:\.\d+)?\s?)*$/;

    #Get numbers into an array
    my @nums = split ' ', $_;

    #Must have at least two numbers
    return unless @nums > 1;

    # initialize the sum
    my $sum;

    # calculate the sum
    $sum += $_ for @nums;

    # get the length of the array
    my $len = @nums;

    # calculate the mean
    my $mean = $sum/$len;

    # sort the list numerically, least to greatest
    @nums = sort { $a <=> $b } @nums;
    my $med;
    if ($len % 2 eq 0) {
        # get the two middle numbers, since the 
        # length is even, and calculate their mean
        $med = ($nums[$len/2] + $nums[$len/2-1])/2;
    } else {
        # get the middle number
        $med = $nums[int($len/2)]
    }

    my $rms;
    $rms += ($_ ** 2) for @nums;
    $rms /= $len;
    $rms = sqrt $rms;
    return "Mean: $mean; Median: $med; Root Mean Square: $rms", html => append_css("<div class='average--container'><div><span class='average--key'>Mean:</span> <span class='average--value'>$mean</span></div> <div><span class='average--key'>Median:</span> <span class='average--value'>$med</span></div> <div><span class='average--key'>Root Mean Square:</span> <span class='average--value'>$rms</span></div></div>");
};

1;
