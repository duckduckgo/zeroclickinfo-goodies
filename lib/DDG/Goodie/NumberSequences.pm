package DDG::Goodie::NumberSequences;
# ABSTRACT: Handling the queries of type nth number of type m. Sequences of m which are currently supported:

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
                abundant           => 'Abundant', 
                aronson            => 'NumAronson', 
                beastly            => 'Beastly', 
                catalan            => 'Catalan', 
                cube               => 'Cubes', 
                cullen             => 'CullenNumbers', 
                duffinian          => 'DuffinianNumbers',
                even               => 'Even', 
                factorial          => 'Factorials', 
                fibbinary          => 'Fibbinary', 
                fibonacci          => 'Fibonacci', 
                happy              => 'HappyNumbers', 
                harshad            => 'HarshadNumbers', 
                klarnerrado        => 'KlarnerRado', 
                lucas              => 'LucasNumbers', 
                lucky              => 'LuckyNumbers', 
                moran              => 'MoranNumbers', 
                odd                => 'Odd', 
                palindrome         => 'Palindromes', 
                pell               => 'Pell', 
                perrin             => 'Perrin', 
                prime              => 'Primes', 
                primorial          => 'Primorials', 
                pronic             => 'Pronic', 
                proth              => 'ProthNumbers', 
                square             => 'Squares', 
                star               => 'StarNumbers', 
                tetrahedral        => 'Tetrahedral', 
                triangular         => 'Triangular', 
                tribonacci         => 'Tribonacci', 
                ulam               => 'UlamSequence', 
                undulating         => 'UndulatingNumbers', 
                woodall            => 'WoodallNumbers', 
                xenodrome          => 'Xenodromes'
        );

my $seq_reg = join("|", keys %seq_packages);
my $number_re = number_style_regex();
my $question_re = "is|[?]";
my $ordinal_num = "(0|([1-9](\d*|\d{0,2}(,\d{3})*)))(st|nd|rd|th)";
my $oeis_re = "oeis";
my $normal_num = "[1-9][0-9]*";

my @triggers_all_small = keys %seq_packages;
my @triggers_first_capital = map { ucfirst $_ } keys %seq_packages;
my @triggers_all_capital = map { uc $_ } keys %seq_packages;

triggers any => (@triggers_all_small, @triggers_first_capital, @triggers_all_capital);

handle query_parts => sub {

    my @tokens = @_;
    return unless ((true { /$number_re/ } @tokens) == 1) || ((true { /^$oeis_re$/i } @tokens) > 0);

    my ($type) = grep(/$seq_reg/i, @tokens);
    $type = lc $type;
    $type = join('', $type =~ /[a-z]+/g);

    my ($answer, $title, $subtitle) = (undef, undef, undef);
    
    if(grep(/^$oeis_re$/i, @tokens)){
        $title = get_oeis($type);
        $type = ucfirst $type;
        $answer = "OEIS Number for $type Sequence is:";
        $subtitle = "$type OEIS Number";
    } elsif(grep(/$number_re/, @tokens)){

        my ($raw_number) = grep(/$number_re/, @tokens);
        my $number = join('',$raw_number =~ /(\d+)/g);
        print $number;
        
        if ($raw_number =~ /$ordinal_num/){

            $title = get_number($type, $number);
            $type = ucfirst($type);
            my $_raw_number = ordinate($number);
            $answer = "$_raw_number $type is:";
            $subtitle = "$_raw_number $type number";

        } elsif($raw_number =~ /$normal_num/){

            my $flag = get_answer($type, $number);
            $title = $flag ? 'Yes' : 'No';
            $type = ucfirst $type;
            $answer = "Is $number a $type number ?";
            $subtitle = $flag ? "Yes, $number is a $type number" : "No, $number is not a $type number";

        }
    }
    return unless $answer;

    return $answer,
           structured_answer => {

               data => {
                   title    => $title,
                   subtitle => $subtitle
               },

               templates => {
                   group => 'text',
               }
           };
};

sub seq_create_helper {
    my $module = load_module($_[0]);
    return create_seq($module);
}

sub load_module {
    my $module = $module_name.'::'.$seq_packages{$_[0]};
    load $module;
    return $module;
}

sub create_seq {
    return $_[0]->new();
}

sub get_number {
    my $seq = seq_create_helper($_[0]);
    my $result =  nth_number($seq, $_[1]);
    return $result;
}



sub nth_number {
    my $seq = $_[0];
    if ($seq->can('ith')){
        return $seq->ith($_[1]);
    } else {
        while (my ($i, $value) = $seq->next) {
            return $value if $i == $_[1];
        }
    }
}

sub get_oeis {
    my $seq = seq_create_helper($_[0]);
    my $oeis_num =  $seq->oeis_anum;
    return $oeis_num;
}

sub get_answer {
   my $type = ucfirst $_[0];
   my $seq = seq_create_helper($_[0]);
   return unless $seq->can('pred');
   my $flag = check_value_to_i($seq, $_[1]);
   return $flag;
}

sub check_value_to_i {
    return $_[0]->pred($_[1]);
}
1;
