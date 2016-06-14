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

        my ($title, $subtitle, @record_data, @record_keys);

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


        my @temp_keys;
        my @out;
        foreach my $key (sort keys %freq) {
            push( @temp_keys, $key );
            push @out, join ":", $key, $freq{$key} . "/" . $count;
        };

        @record_data = \%freq;
        @record_keys = \@temp_keys;

        my $plaintext = join ' ', @out;

        return $plaintext,
        structured_answer => {
            data => {
                title => "Frequency",
                record_data => @record_data,
                record_keys => @record_keys
            },
            meta => {},
            templates => {
                group => 'list',
                options => {
                    content => "record"
                },
            },
        } if @out;
    };

    return;
};

zci is_cached => 1;

1;
