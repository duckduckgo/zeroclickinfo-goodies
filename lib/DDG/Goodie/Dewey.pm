package DDG::Goodie::Dewey;
# ABSTRACT: Identify and find dewey decimal system numbers

use strict;
use DDG::Goodie;

triggers any => 'dewey';

zci answer_type => 'dewey_decimal';

zci is_cached => 1;

# create a hash with the numbers as keys
my %nums = share('dewey.txt')->slurp;
# create another with the descriptions as keys
my %types = reverse %nums;

# get description for a number
sub get_info {
    # The number is the value passed into the subroutine
    my($num) = @_;
    # The description is the value for the number key
    my $desc = $nums{"$num\n"} or return;
    chomp $desc;
    return $desc;
}

# return a line of html for the list
sub line {
    my($num) = @_;
    chomp $num;
    # return html table cells (change this)
    return "<td>$num</td><td>&nbsp;".(get_info($num) or return)."</td>";
}

# return the single line answer
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

    # my ($out_html, $out) = ("","");

    # the 's' like in '400s'
    my $multi = $2;
    # words that might describe the category
    my $word = $3;

    # if the words exist:
    if (defined $word) {
        return if lc($word) eq 'system'; # don't respond to "dewey decimal system"

        # search the descriptions for the words
        my @results = grep(/$word/i, keys %types);
        # if it doesn't find anything, don't respond
        return unless @results;
        # if there are more than 1 results, create a table with multiple rows
        if (@results > 1) {
            # change this
            # add a new line (using the line sub) for each thing in the results array
            $out_html .= "<tr>".line($types{$_})."</tr>" for @results;
            $multi = 1;
        } else {
            # if not, 
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
    # return ($multi) ? "" : $out, html => ($multi) ? "<table cellpadding=1>$out_html</table>" : $out_html;
    return structured_answer => {
            id => 'dewey_decimal',
            name => 'Answer',
            data => %result
            templates => {
                group => 'list'
                options => {
                    content => 'record'
                }
            }
        };
};

1;
