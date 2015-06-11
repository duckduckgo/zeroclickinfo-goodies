package DDG::Goodie::Bitsum;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;
use strict;

zci answer_type => "bitsum";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "Bitsum";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Bitsum.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers start => "bitsum", "hammingweight";

# Handle statement
handle remainder => sub {
    
    # optional - regex guard
    # return unless qr/^\w+/;

    return unless $_; # Guard against "no answer"

    my $n = $_;
    my $c;
    for ($c = 0; $n; $n >>= 1) { 
        $c += $n & 1; 
    } 

    my $result = $c;
    
    return $result,
        structured_answer => {
            input     => [html_enc($_)],
            operation => 'Hamming Weight',
            result    => html_enc($result),
        };
};


1;
