package DDG::Goodie::NumberSequences;
# ABSTRACT: Handling the queries of type nth number of type m. Sequences of m which are currently supported:
# - Prime
# - Catalan
# - Tetrahedral

use DDG::Goodie;
use Lingua::EN::Numbers::Ordinate; 
use Module::Load;
with 'DDG::GoodieRole::NumberStyler';
use List::MoreUtils 'true';
use strict;
use warnings;
zci answer_type => 'number_sequences';

zci is_cached => 1;

my $module_name = 'Math::NumSeq';

my %seq_packages = (
        prime           => 'Primes',
        catalan         => 'Catalan',
        tetrahedral     => 'Tetrahedral'
        );

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
               },

               templates => {
                   group => 'text',
               }
           };
};

sub get_number{
    my $module = $module_name.'::'.$seq_packages{$_[0]};
    load $module;
    my $cmd = $module."->new()";
    my $seq = eval $cmd;
    if ($seq->can('ith')){
        return $seq->ith($_[1]);
    } else {
        while (my ($i, $value) = $seq->next) {
            return $value if $i == $_[1];
        }
    }
}

1;
