package DDG::Goodie::NextPermutation;
#ABSTRACT : Generating lexicographically next permutation of sequence
use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'next_permutation';
zci is_cached => 1;
triggers startend => 'next permutation', 'next perm';

handle remainder => sub {
    return unless /^([A-za-z]+|[0-9]+)$/;
    my @array = split('',$_);
    my $org_seq = $_;
    my $index = swapable_index(@array);
    return unless $index >= 0;
    my $index2 = min_greatest(\@array, $index);
    @array[$index, $index2] = @array[$index2,$index];
    @array = sort_index(\@array, $index);
    my $result = join('', @array);
    return "Next Permutation of the Sequence is $result",
        structured_answer => {
            data => {
                title    => $result,
                subtitle => "Lexicographically Next Permutation For Sequence: $org_seq"
            },
            templates => {
                group => 'text'
            }
        };
};

sub swapable_index{
    my @array = @_;
    my $result = -1;
    foreach my $i (0..$#array-1){
    $result = ($array[$i] lt $array[$i+1]) ? $i : $result;
    }
    return $result
}

sub sort_index{
    my @array= @{$_[0]};
    my $index = $_[1];
    my @subarray = @array[$index+1..$#array];
    @subarray = sort { $a cmp $b} @subarray;    
    splice @array, $index + 1, $#subarray + 1, @subarray;
    return @array;
}

sub min_greatest{
    my @array = @{$_[0]};
    my $start_index = $_[1];
    my $end_index = $#array;
    while($end_index > $start_index){
        last if $array[$end_index] gt $array[$start_index];
        $end_index--; 
    }    
    return $end_index;
}
1;
