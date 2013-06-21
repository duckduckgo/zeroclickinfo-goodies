package DDG::Goodie::Combinations;

use DDG::Goodie;

triggers any => 'choose';
zci is_cached => 1;
zci answer_type => 'combination';

primary_example_queries '5 choose 3';
description 'Returns the number of combinations of size k which can be made from n objects (nCk).';
attribution github => ['https://github.com/conorfl', 'conorfl'],
twitter => '@areuhappylucia';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Combinations.pm';
topics 'math';
category 'calculations';

handle remainder => sub {
    s/^\s+//;
    s/\s+$//;
    if($_ =~ /^(\d+)(?:\s+)(\d+)$/){
        if($2 > $1){
            return $1 . " choose " . $2 . " = 0";
        }
        my $n = $1; 

        my $k = $2;
        my $combi = 1;
        for my $i (($k+1)..$n) {
            $combi *= $i;
        }
        for my $j (1..($n-$k)){
            $combi /= $j
        }
        return $n . " choose " . $k . " = " . $combi;
    }
    return $_;
};

1;