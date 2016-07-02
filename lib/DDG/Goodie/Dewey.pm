package DDG::Goodie::Dewey;
# ABSTRACT: Identify and find dewey decimal system numbers

use strict;
use DDG::Goodie;

triggers any => 'dewey';
zci answer_type => 'dewey_decimal';
zci is_cached => 1;

my %nums = share('dewey.txt')->slurp;
my %types = reverse %nums;

# get description for a number
sub get_info {
    my($num) = @_;
    my $desc = $nums{"$num\n"} or return;
    chomp $desc;
    $desc =~ s/\[\[([^\]]+?)\|(.+?)\]\]/$2/g;
    $desc =~ s/\[\[(.+?)\]\]/$1/g;
    $desc =~ s/\[\[.+?\|(.+?)\]\]/$1/g;
    $desc =~ s/\[\[(.+?)\]\]/$1/g;
    return $desc;
}

# add a key-value pair with number and description to $data
sub line {
    my($num, $data) = @_;
    chomp $num;
    if(exists($nums{"$num\n"})) {
        $data->{$num} = get_info($num) or return;
    }
}

handle remainder => sub {
    return unless s/^(?:the)?\s*(?:decimal)?\s*(?:system)?\s*(?:numbers?|\#)?\s*
                    (?:
                        (\d{1,3})(?:\.\d+)?(s)? |
                        ([\w\s]+?)
                    )
                    \s*(?:in)?\s*(?:the)?\s*(?:decimal)?\s*(?:system)?$
                    /defined $1?$1:$3/eix;

    # the 's' like in '400s'
    my $multi = $2;
    # words that might describe the category
    my $word = $3;
    #output rows
    my $output = {};
    
    if (defined $word) {
        return if lc($word) eq 'system'; # don't respond to "dewey decimal system"

        my @results = grep(/$word/i, keys %types);

        return unless @results;

        if (@results > 1) {
            line($types{$_}, $output) for @results;
            $multi = 1;
        } else {
            my $num = $types{$results[0]};
            line($num, $output);
        }
    }

    else {
        $_ = sprintf "%03d", $_;

        unless ($multi) {
            line($_, $output);
        }
        elsif (/\d00/) {
            for ($_..$_+99) {
                line($_, $output) or next;
            }
        }
        elsif (/\d\d0/) {
            for ($_..$_+9) {
                line($_, $output) or next;
            }
        }
    }

    return $output, structured_answer => {
            id => 'dewey_decimal',
            name => 'Answer',
            templates => {
                group => 'list',
                options => {
                    content => 'record',
                    moreAt => 0
                }
            },
            data => {
                title => 'Dewey Decimal System',
                record_data => $output
            }
        };
};

1;
