package DDG::Goodie::NumberSequences;
# ABSTRACT: Handling the queries of type nth number of type m. Sequences of m which are currently supported:
# - Prime
# - Catalan

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate; 
use Module::Load;
use strict;
use warnings;
zci answer_type => 'number_sequences';

zci is_cached => 1;

triggers any => 'number';

our %seq_packages = (
    'PRIME' => ['Math::Prime::Util', '::nth_prime(NUM)' ],
    'CATALAN' => ['Math::NumSeq::Catalan','->new()->ith(NUM)' ],
    'TETRAHEDRAL' => ['Math::NumSeq::Tetrahedral','->new()->ith(NUM)']
);

our $find='NUM';

handle remainder => sub {
    
    #return unless /^\s*\d+(?:(?:\s|,)+\d+)*\s*$/;
    my @tokens = split /\s+/;
    my ($raw_number) = grep(/^\d/, @tokens);
    my ($type) = grep(/^[a-zA-Z]+$/, @tokens);
    $type = uc $type;
    my ($number) = $raw_number =~ /(\d+)/;
    $raw_number = ordinate($number);
    
    return unless exists $seq_packages{$type};
    my $result = get_number($type,$number);
    return unless $result;
    

    $type = ucfirst lc $type;
    return "$raw_number $type is:",
        structured_answer => {

            data => {
                title    => "$result",
                subtitle => "$raw_number $type number"
                # image => 'http://website.com/image.png',
            },

            templates => {
                group => 'text',
                # options => {
                #
                # }
            }
        };
};

sub get_number{
    my $module =$seq_packages{$_[0]}[0];
    my ($cmd_part) = $seq_packages{$_[0]}[1]; 
    load $module;
    my $cmd = "$module$cmd_part";
    $cmd =~ s/$find/$_[1]/;
    return eval $cmd;
}

1;
