package DDG::Goodie::FindAnagrams;

use DDG::Goodie;
use JSON;
#use Data::Dumper;

zci is_cached => 1;

triggers start => "anagram", "anagrams";

my $json = share('words.json')->slurp;

my %wordHash = %{decode_json($json)};

#print Dumper(\%wordHash);


handle remainder => sub {

    s/of //g;

    # Format string to look like hash key by making it lowercase
    # then splitting the string into chars, sort them and finally
    # join back into sorted string
    my $sorted_string = join("",sort(split(//,lc($_))));

    my @resultArray = ();

    if (exists $wordHash{$sorted_string}) {
        push(@resultArray, @{$wordHash{$sorted_string}});
    } else {
        return;
    }

    my $index = 0;

    $index++ until $resultArray[$index] eq $_;

    splice(@resultArray, $index, 1);

    my $result_string = join(", ",@resultArray);

    return $result_string unless $result_string eq "";
};

1;
