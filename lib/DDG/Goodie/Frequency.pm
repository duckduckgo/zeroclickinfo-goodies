package DDG::Goodie::Frequency;
# ABSTRACT: Displays frequency of alphabet character (a-z)

use strict;
use DDG::Goodie;

triggers start => 'frequency', 'freq';

handle remainder => sub {
    if ($_ =~ /^of ([a-z]|(?:all ?|)(?:letters|characters|chars|)) in (.+)/i) {

        my $collect = lc $1;
        my $target_str = lc $2;

#     	warn qq($collect\t$target_str\n);

        my $count = 0;
        my %freq;
        my @chars = split //, $target_str;

        foreach (@chars) {
            if ($_ =~ /[a-z]/) {
                if ($collect =~ /all|letters|characters|chars/) {
                    ++$freq{$_};
                }
                else {
                    ++$freq{$_} if $_ eq $collect;
                }

                ++$count;
            };
        };

        my $list_data = [];
        foreach my $key (sort keys %freq) {
            my $temp_hash = {
                alphabet => "$key",
                frequency => "$freq{$key}"
            };
            push( @$list_data, $temp_hash );
        }

        my @out;
        foreach my $key (keys %freq) {
        push @out, join " ", $key, $freq{$key} . "/" . $count;
        };

        my $plaintext = join ' ', @out if @out;
    	
        return $plaintext,
        structured_answer => {
            data => {
                title => "Frequency",
                list => $list_data
            },
            meta => {},
            templates => {
                group => 'list',
                options => {
                    list_content => "DDH.frequency.list_content"
                },
            },
        };;
    };

    return;
};

zci is_cached => 1;

1;
