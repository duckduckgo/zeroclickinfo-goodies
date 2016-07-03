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
sub add_line {
    my($num, $data) = @_;
    chomp $num;
    if(exists($nums{"$num\n"})) {
        $data->{$num} = get_info($num) or return;
    }
}

handle remainder => sub {
    return unless /^(?:the)?\s*(?:decimal)?\s*(?:system)?\s*(?:numbers?|\#)?\s*
                    (?:
                        (?<num>\d{1,3})(?:\.\d+)?(?<multi>s)? |
                        (?<word>[\w\s]+?)
                    )
                    \s*(?:in)?\s*(?:the)?\s*(?:decimal)?\s*(?:system)?$/ix;

    my $word = $+{'word'};
    my $output = {};
    
    if (defined $word) {
        return if lc($word) eq 'system';
        my @results = grep(/$word/i, keys %types);
        return unless @results;
        add_line($types{$_}, $output) for @results;
    }
    else {
        my $formatted_num = sprintf "%03d", $+{'num'};
        unless($+{'multi'}) {
            add_line($formatted_num, $output)
        }
        elsif ($formatted_num =~ /\d00/) {
            for my $x ($formatted_num .. $formatted_num+99) {
                add_line($x, $output) or next;
            }
        }
        elsif ($formatted_num =~ /\d\d0/) {
            for my $x ($formatted_num .. $formatted_num+9) {
                add_line($x, $output) or next;
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
