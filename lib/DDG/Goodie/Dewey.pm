package DDG::Goodie::Dewey;
# ABSTRACT: Identify and find dewey decimal system numbers

use DDG::Goodie;

triggers any => 'dewey';

zci answer_type => 'dewey_decimal';

zci is_cached => 1;

primary_example_queries 'dewey 644';
secondary_example_queries 'etymology in the dewey decimal system', 'dewey decimal system 640s', 'dewey decimal system naturalism';
description 'get the topic or reference number of a Dewey Decimal class';
name 'Dewey';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Dewey.pm';
category 'reference';
topics 'special_interest';
attribution twitter => 'crazedpsyc',
            cpan    => 'CRZEDPSYC' ;

my %nums = share('dewey.txt')->slurp;
my %types = reverse %nums;

sub get_info {
    my($num) = @_;
    my $desc = $nums{"$num\n"} or return;
    chomp $desc;
    return $desc;
}

sub line {
    my($num) = @_;
    chomp $num;
    return "<td>$num</td><td>&nbsp;".(get_info($num) or return)."</td>";
}

sub single_format {
    "$_[0] is $_[1] in the Dewey Decimal System.";
}

handle remainder => sub {
    return unless s/^(?:the)?\s*(?:decimal)?\s*(?:system)?\s*(?:numbers?|\#)?\s*
                    (?:
                        (\d{1,3})(?:\.\d+)?(s)? |
                        ([\w\s]+?)
                    )
                    \s*(?:in)?\s*(?:the)?\s*(?:decimal)?\s*(?:system)?$
                    /defined $1?$1:$3/eix;

    my ($out_html, $out) = ("","");

    my $multi = $2;
    my $word = $3;

    if (defined $word) {
        return if lc($word) eq 'system'; # don't respond to "dewey decimal system"
        my @results = grep(/$word/i, keys %types);
        return unless @results;
        if (@results > 1) {
            $out_html .= "<tr>".line($types{$_})."</tr>" for @results;
            $multi = 1;
        } else {
            my $num = $types{$results[0]};
            chomp $num;
            $out .= single_format($num, lc(get_info($num) or return));
            $out_html = $out;
        }
    }

    else {
        $_ = sprintf "%03d", $_;

        unless ($multi) {
            $out .= single_format $_, lc((get_info($_) or return));
            $out_html = $out;
        }
        elsif (/\d00/) {
            for ($_..$_+99) {
                $out_html .= "<tr>" .(line($_) or next). "</tr>";
            }
        }
        elsif (/\d\d0/) {
            for ($_..$_+9) {
                $out_html .= "<tr>" .(line($_) or next). "</tr>";
            }
        }
    }

    $out_html =~ s/\[\[([^\]]+?)\|(.+?)\]\]/<a href="\/\?q=$1">$2<\/a>/g;
    $out_html =~ s/\[\[(.+?)\]\]/<a href="\/?q=$1">$1<\/a>/g;
    $out =~ s/\[\[.+?\|(.+?)\]\]/$1/g;
    $out =~ s/\[\[(.+?)\]\]/$1/g;
    return ($multi) ? "" : $out, html => ($multi) ? "<table cellpadding=1>$out_html</table>" : $out_html;
};

1;
