package DDG::Goodie::AspectRatio;
# ABSTRACT: Calculates aspect ratio based on previously defined one

use strict;
use DDG::Goodie;

triggers start => "aspect ratio";

zci is_cached => 1;
zci answer_type => "aspect_ratio";

handle remainder => sub {
    my $input  = $_;
    my $result = 0;
    my $ratio  = 0;

    if ($input =~ /^(\d+(?:\.\d+)?)\s*\:\s*(\d+(?:\.\d+)?)\s*(?:(?:(\?)\s*:\s*(\d+(?:\.\d+)?))|(?:(\d+(?:\.\d+)?)\s*:\s*(\?)))$/) {
        $ratio = $1 / $2;
        my $pretty_ratio = $1 . ':' . $2;

        my $result;
        if ($6 && $6 eq "?") {
            $result = $5 . ':' . ($5 / $ratio);
        } elsif ($3 && $3 eq "?") {
            $result = ($4 * $ratio) . ':' . $4;
        }
        return unless $result;

        return "Aspect ratio: $result ($pretty_ratio)",
            structured_answer => {
                data => {
                    title    => $result,
                    subtitle => 'Aspect ratio: ' . $pretty_ratio,
                },
                templates => {
                    group => 'text',
                }
            };
    }
};

1;
