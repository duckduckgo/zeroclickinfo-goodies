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
triggers any => qw(plus minus + - before after);

my $number_re = number_style_regex();
my $action_re = qr/(?<action>plus|add|\+|\-|minus|subtract)/i;

my $day_re = qr/(?<day>$number_re)\s+(day|days)/i;
my $hour_re = qr/(?<hour>$number_re)\s+(hour|hours)/i;
my $min_re = qr/(?<min>$number_re)\s+(minute|minutes)/i;
my $sec_re = qr/(?<sec>$number_re)\s+(second|seconds)/i;

my $operand_re = qr/($day_re\s+)?($hour_re\s+)?($min_re\s+)?($sec_re\s*)?/i;
my $operation_re = qr/(?<operand1>$operand_re)$action_re\s+(?<operand2>$operand_re)?/i;

;
my $full_time_regex = qr/^($operation_re)[\?.]?$/i;



sub format_result {
    my ($result) = @_;
    
    my $span = DateTime::Format::Human::Duration->new();
    return $span->format_duration($result)
}
sub get_action_for {
    my $action = shift;
    return '+' if $action =~ /^(\+|plus)$/i;
    return '-' if $action =~ /^(\-|minus)$/i;
}

sub get_values{
    my ($operand) = @_;
    $operand =~ $operand_re;

    my $day = $+{day};
    my $hour = $+{hour};
    my $min = $+{min};
    my $sec = $+{sec};

    $day = "0" unless defined $day;
    $hour = "0" unless defined $hour;
    $min = "0" unless defined $min;
    $sec = "0" unless defined $sec;
    
    return ($day, $hour, $min, $sec);
}

sub add{
    my ($dur1, $dur2) = @_;
    
    my $dur = $dur1->add($dur2);
    return format_result($dur);
}

sub subtract{
	my ($dur1, $dur2) = @_;
    my $dur = $dur1->subtract($dur2);
    return format_result($dur);
}

sub get_result {
    my ($values1, $values2, $action) = @_;
    
    return  add ($values1, $values2) if $action eq '+';
    return subtract ($values1, $values2) if $action eq '-';
}

handle query_lc => sub {
    my $query = $_;

    return unless $query =~ $full_time_regex;

    my $action = $+{action};
    my $operand1= $+{operand1};
    my $operand2 = $+{operand2};

    my @values1 = get_values($operand1);
    my @values2 = get_values($operand2);
    
    my $dur1 = DateTime::Duration->new(days=>$values1[0], hours=>$values1[1], minutes=>$values1[2], seconds=>$values1[3]);
    my $dur2 = DateTime::Duration->new(days=>$values2[0], hours=>$values2[1], minutes=>$values2[2], seconds=>$values2[3]);
    
    $action = get_action_for($action);
    my $result = get_result ($dur1, $dur2, $action);
    
    return $result,
        structured_answer => {

            data => {
                title    => $result,
                #subtitle => "My Subtitle",
                # image => "http://website.com/image.png",
            },

            templates => {
                group => "text",
                # options => {
                #
                # }
            }
        };
};

1;
