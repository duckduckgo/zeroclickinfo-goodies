package DDG::Goodie::TextConverter;
# ABSTRACT: An Instant Answer to convert between different formats
# eg. ASCII, Binary, hexadecimal, etc

use DDG::Goodie;
use strict;
use warnings;

use List::Util 'max';
use YAML::XS 'LoadFile';

zci answer_type => 'text_converter';
zci is_cached => 0;

my @triggers = ();
my @lang_triggers = ();
my %natlang_hash = %{ LoadFile(share('text_converter.yml')) };

my @generics = qw/
    converter
    conversion
    encoder
    encode
    decoder
    decode
/;

my $generics_re = join "|", @generics;

while( my( $key, $value ) = each %natlang_hash ){
    if($value) {
        push(@triggers,  $key);
        foreach(@$value) {
            push(@triggers, $_);
        }
    } else {
        push(@triggers, $key);
    }
}

for my $trig (@triggers) {
    push @lang_triggers, map { "$trig $_" } @generics;
}

triggers any => (
    @lang_triggers,
);


# checks the /type/ of the query
# eg. binary converter --> binary
sub get_type_information {
    my $input = shift;
    p($generics_re);
    $input =~ s/$generics_re|\s//gi;

    foreach my $key (keys %natlang_hash) {
        return $key if $key eq $input;
        if($natlang_hash{$key}) {
            my @hash_kv = @{$natlang_hash{$key}};
            foreach my $value (@hash_kv) {
                return $key if $input eq $value;
            }
        }
    }
    # if not assigned such as 'unit calculator' we'll default to length
    return 'ascii';
}

handle query => sub {

    my $query = $_;
    my $from_type = "";
    my $to_type = "";

    ##
    ## Language Triggers
    ##
    ## eg. Binary Converter, ascii conversion
    ##

    if(grep(/^$_$/, @lang_triggers)) {
        $from_type = get_type_information($_);
    }

    return '',
        structured_answer => {

            data => {
                title    => "Text Converter",
                subtitle => "Various Text Conversion Tools",
                from_type => $from_type,
                to_type => $to_type 
            },
            templates => {
                group => 'text',
            }
        };
};

1;
