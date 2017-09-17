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
my @single_triggers = ();
my @lang_triggers = ();
my %natlang_hash = %{ LoadFile(share('text_converter.yml')) };

my @keys = keys %natlang_hash;
push @single_triggers, (keys %natlang_hash);

while( my( $key, $value ) = each %natlang_hash ){
    if($value) {
        foreach(@$value) {
            push(@triggers, $_);
        }
    } else {
        push(@triggers, $key);
    }
}

my @generics = qw/ converter convert conversion translate translator translation encoder encode decoder decode /;
my @merged_triggers = (@single_triggers, @triggers);
my $triggers_re = join "|", @merged_triggers;
my $generics_re = join "|", @generics;

# for static language based triggers e.g. 'base64 decode'
# these words mean we want to go from the type in the query to text
my @from_words = ('decoder', 'decode', 'converter', 'translator');
my $from_words_re = join '|', @from_words;
# these words mean we want to go from text to the type in the query
my @to_words = ('encode', 'encoder', 'translation', 'translate', 'convert', 'conversion');
my $to_words_re = join '|', @to_words;

for my $trig (@triggers) {
    push @lang_triggers, map { "$trig $_" } @generics;
}

my $guard = qr/^
                (?:$generics_re)?\s?
                (?<from_type>$triggers_re)\s
                (?<connector>to|from|vs|-)\s
                (?<to_type>$triggers_re)\s?
                (?:$generics_re)?
               $
              /ix;

triggers any => (
    @triggers,
    @single_triggers,
    @lang_triggers,
);

handle query_lc => sub {

    my $query = $_;
    my $from_type = "";
    my $to_type = "";

    # check to see if the query is a command based trigger
    # eg. binary to ascii, decimal from ascii, convert binary to ascii
    if(m/$guard/) {
        $from_type = get_type_information($+{'from_type'});
        $to_type = get_type_information($+{'to_type'});
        my $connector = $+{'connector'};

        # the user wants to convert /from/, we'll switch the types
        if ($connector eq 'from') {
            ($from_type, $to_type) = ($to_type, $from_type);
        }

        return '',
            structured_answer => {

                data => {
                    title    => "Text Converter",
                    from_type => $from_type,
                    to_type => $to_type 
                },
                templates => {
                    group => 'text',
                }
            };
    }

    # check to see if query is a static language based trigger
    # eg. binary converter, hex encoder
    if(grep(/^$query$/, @lang_triggers)) {
        if ($query =~ /${from_words_re}/gi) {
            $from_type = get_type_information($query);
        } elsif ($query =~ /${to_words_re}/gi) {
            $to_type = get_type_information($query);            
        }

        return '',
            structured_answer => {

                data => {
                    title    => "Text Converter",
                    from_type => $from_type,
                    to_type => $to_type 
                },
                templates => {
                    group => 'text',
                }
            };
    }

    return;
};

# checks the /type/ of the query
# eg. binary converter --> binary
sub get_type_information {
    my $input = shift;
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
    return 'text'; # default to text
}

1;
