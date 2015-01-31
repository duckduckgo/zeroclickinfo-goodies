package DDG::Goodie::Combination;
# ABSTRACT: Compute combinations and permutations

use DDG::Goodie;
with 'DDG::GoodieRole::NumberStyler';

zci answer_type => "combination";
zci is_cached   => 1;

name "Combination";
description "Computes combinations and permutations.";
primary_example_queries "10 choose 3", "25 permute 16";
secondary_example_queries "16 permutation 3";
category "calculations";
topics "math";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Combination.pm";
attribution github => ["richardscollin", "Collin Richards"];

triggers any => "choose", "permute", "permutation", "npr", "ncr";

my $number_re = number_style_regex();

# Handle statement
handle query => sub {
    my $query = $_;
    return unless /^($number_re) (choose|permute|permutation|npr|ncr) ($number_re)$/i;

    my $style = number_style_for($1,$3);
    return unless $style; #Cannot determine number format
    my $operation = lc $2;

    #If contains a 'p' then it is permutation
    if (index($operation, 'p') != -1) {
        $operation = 'permute';
    } else {
        $operation = 'choose';
    }

    #$n choose $k
    my $n = $style->for_computation($1);
    my $k = $style->for_computation($3);

    #Ensure both are non-negative integers
    return unless $n =~ /^\d+$/ && $k =~ /^\d+$/;

    #Do not try to calculate undefined combinations
    return unless $n >= $k;

    my $result;

    if ('choose' eq $operation) {
        $result = choose($n, $k);
    } else { #must be permute
        $result = permute($n, $k);
    }

    #Return no result if overflow
    return if $result eq '-nan' or $result eq 'nan';

    my $formatted_result = $style->for_display($result);

    return $formatted_result,
    structured_answer => {
        input     => [$style->for_display($n) . " $operation " . $style->for_display($k)],
        operation => 'Calculate',
        result    => $formatted_result,
    };
};

#Computes the cumulative product of the numbers from $_[0] to $_[1] inclusive
#Do not call when first parameter is greater then second.
sub cumprod {
    my $acc = 1;
    for (my $i = $_[0]; $i <= $_[1]; $i++) {
        $acc *= $i;
    }
    return $acc;
}

sub choose {
    my ($n, $k) = @_;

    #optimiztion combination is semetric
    my $diff = $n - $k;
    if ($k > $diff) {
        $k = $diff;
    }
    return cumprod($n - $k + 1, $n) / cumprod(1, $k);
}

sub permute {
    my ($n, $k) = @_;
    return cumprod($n - $k + 1, $n);
}

1;
