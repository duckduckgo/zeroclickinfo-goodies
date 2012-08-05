package DDG::Goodie::Dewey;
# ABSTRACT: Identify and find dewey decimal system numbers

use DDG::Goodie;

triggers startend => 'dewey';

zci answer_type => 'dewey_decimal';

zci is_cached => 1;

attribution 
    twitter => 'crazedpsyc',
    cpan    => 'CRZEDPSYC'
;

my %nums = share('dewey.txt')->slurp;
#my %types = reverse %nums;

sub get_info {
    my($num) = @_;
    $num = "0" x (3-length($num)) . $num;
    my $desc = $nums{"$_\n"} or return;
    chomp $desc;
    return $desc;
}

sub line {
    my($num) = @_;
    return "<td>$num</td><td>".(get_info($num) or return)."</td>";
}

handle remainder => sub {
    return unless s/^(?:decimal)?\s*(?:system)?\s*(\d{3})(?:\.\d+)?(s)?\s*(?:decimal)?\s*(?:system)?$/$1/;
    my ($out_html, $out) = ("","");

    my $multi = $2;

    unless ($multi) { 
        $out .= "$_ is " . lc((get_info($_) or return));
        $out .= " in the Dewey Decimal System";
        $out_html = $out;
    }
    elsif (/\d00/) {
        for ($_..$_+99) {
            $out_html .= "<tr>" .(line($_) or next). "</tr>";
        }
    }
    elsif (/\d\d0/) {
        for ($_..$_+10) {
            $out_html .= "<tr>" .(line($_) or next). "</tr>";
        }
    }
    
    $out_html =~ s/\[\[(.+?)\|(.+?)\]\]/<a href="\/\?q=$1">$2<\/a>/g;
    $out_html =~ s/\[\[(.+?)\]\]/<a href="$1">$1<\/a>/g;
    $out =~ s/\[\[.+?\|(.+?)\]\]/$1/g;
    $out =~ s/\[\[(.+?)\]\]/$1/g;
    return $multi ? "" : $out, html => $multi ? "<table>$out_html</table>" : $out_html;
};

1;
