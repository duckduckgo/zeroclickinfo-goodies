package DDG::Goodie::AspectRatio;
# ABSTRACT: Calculates aspect ratio based on previously defined one

use DDG::Goodie;


zci is_cached => 1;
zci answer_type => "aspect_ratio";
triggers start => "aspect";

handle query_parts => sub {
    shift;
    return unless lc(shift) eq "ratio";
    my $input = join(' ', @_);
    my $result = 0;
    my $ratio = 0;

    if ($input =~ /^(\.\d+)\s*\:\s*(\.\d+)\s*(?:(?:(\?)\s*:\s*(\d+(?:\.\d+)?))|(?:(\d+(?:\.\d+)?)\s*:\s*(\?)))$/){
        $ratio = $1 / $2;

        if ($6 && $6 eq "?") {
            $result = $5 / $ratio;
            return "Aspect ratio $1:$2 -> $5:$result";
        } elsif ($3 && $3 eq "?") {
            $result = $4 * $ratio;
            return "Aspect ratio $1:$2 -> $result:$4";
        }
    }
    return;
};

1;
