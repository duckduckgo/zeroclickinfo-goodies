package DDG::Goodie::DurationCalculator;
# ABSTRACT: Finds duration between two times

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';
with 'DDG::GoodieRole::NumberStyler';
use DateTime::Duration;
use DateTime::Format::Human::Duration;
use Lingua::EN::Numericalize


zci answer_type => 'duration_calculator';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => qw(second minute hour day);
triggers any => qw(seconds minutes hours days);
triggers any => qw(plus minus + - add subtract);

my $number_re = number_style_regex();
my $action_re = qr/(?<action>plus|add|\+|\-|minus|subtract)/i;
my $unit_re = qr/(year|month|week|day|hour|minute|second|nanosecond)s?/i;
my $term_re = qr/(?<number>$number_re)\s(?<unit>$unit_re)/i;
my $operand_re = qr/($term_re\s?)*/i;

my $operation_re = qr/(?<operand1>$operand_re)$action_re\s+(?<operand2>$operand_re)?/i;

my $full_time_regex = qr/^($operation_re)[\?.]?$/i;



sub format_result {
    my ($result) = @_;
    
    my $span = DateTime::Format::Human::Duration->new();
    
    my $start = DateTime->now();
    my $end  = $start->clone->add_duration($result);

    return $span->format_duration_between($start, $end);
}
sub get_action_for {
    my $action = shift;
    return '+' if $action =~ /^(\+|plus)$/i;
    return '-' if $action =~ /^(\-|minus)$/i;
}

sub get_values{
    my ($operand) = @_;
  
    my %modifiers;
    while ($operand =~ /$term_re/g) {
        my $number = $+{number};
        my $unit = $+{unit};
        
        $unit .= 's' unless $unit =~ /s$/;
        
        return if exists $modifiers{$unit};
        $modifiers{$unit} = $number;
    }
    my $dur = DateTime::Duration->new(%modifiers);
    return $dur;
}


sub get_result {
    my ($values1, $values2, $action) = @_;
    
    return  format_result ($values1 + $values2) if $action eq '+';
    
    my $subtract = format_result ($values1 - $values2) if $action eq '-';
    return "-($subtract)" if DateTime::Duration->compare($values1, $values2) < 0;
    return $subtract;
}

handle query_lc => sub {
    my $query = $_;

    return unless $query =~ $full_time_regex;

    my $action = $+{action};
    my $operand1= $+{operand1};
    my $operand2 = $+{operand2};
    
    my $dur1 = get_values($operand1);
    return unless defined $dur1;
    
    my $dur2 = get_values($operand2);
    return unless defined $dur2;
    
    $action = get_action_for($action);
    my $result = get_result($dur1, $dur2, $action);
    my $format_query = $operand1.$action." ".$operand2;
    return $result,
            structured_answer => {

            data => {
                title    => $result,
                subtitle => $format_query,
            },
            templates => {
                group => "text",
            }
       };
     
};

1;
