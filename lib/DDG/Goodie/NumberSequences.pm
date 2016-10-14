package DDG::Goodie::NumberSequences;
# ABSTRACT: Handling the queries of type nth number of type m. Sequences of m which are currently supported:
# - Prime
# - Catalan

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate; 
use Module::Load;
with 'DDG::GoodieRole::NumberStyler';
use List::MoreUtils 'true';
use strict;
use warnings;
zci answer_type => 'number_sequences';

zci is_cached => 1;


my %seq_packages = (
    prime => ['Math::Prime::Util', '::nth_prime(NUM)' ],
    catalan => ['Math::NumSeq::Catalan','->new()->ith(NUM)' ],
    tetrahedral => ['Math::NumSeq::Tetrahedral','->new()->ith(NUM)']
);

my $find='NUM';

my $seq_reg = join("|", keys %seq_packages);

my $number_re = number_style_regex();

my @triggers_all_small = keys %seq_packages;
my @triggers_first_capital = map { ucfirst $_ } keys %seq_packages;
my @triggers_all_capital = map { uc $_ } keys %seq_packages;

triggers any => (@triggers_all_small, @triggers_first_capital, @triggers_all_capital);

handle query_parts => sub {
    
    my @tokens = @_;
    return unless (true { /$number_re/ } @tokens) == 1;
    my ($raw_number) = grep(/$number_re/, @tokens);
    
    my ($type) = grep(/$seq_reg/i, @tokens);
    $type = lc $type;
    
    my $number = join('',$raw_number =~ /(\d+)/g);
    $raw_number = ordinate($number);
    
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
