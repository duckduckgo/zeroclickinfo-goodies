package DDG::Goodie::DurationCalculator;
# ABSTRACT: Finds duration between two times

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';
with 'DDG::GoodieRole::NumberStyler';
use DateTime::Duration;
use Lingua::EN::Numericalize


zci answer_type => 'duration_calculator';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => qw(second minute hour);
triggers any => qw(seconds minutes hours);
triggers any => qw(plus minus + - before after);

my $number_re = number_style_regex();
my $action_re = qr/(?<action>plus|add|\+|\-|minus|subtract)/i;

my $day_re = qr/(?<day>$number_re)\s+(day|days)/i;
my $hour_re = qr/(?<hour>$number_re)\s+(hour|hours)/i;
my $min_re = qr/(?<min>$number_re)\s+(minute|minutes)/i;
my $sec_re = qr/(?<sec>$number_re)\s+(second|seconds)/i;

my $operand_re = qr/($day_re\s*)?($hour_re\s*)?($min_re\s*)?($sec_re\s*)?/i;
my $operation_re = qr/(?<operand1>$operand_re)$action_re\s+(?<operand2>$operand_re)?/i;

my $what_re = qr/what ((is|was|will) the )?/i;
my $time_re = qr/(?<time>time)/i;
my $will_re = qr/ (was it|will it be|is it|be)/i;
my $full_time_regex = qr/^($what_re?$time_re$will_re? )?($operation_re)[\?.]?$/i;



sub format_result {
    my (@result) = @_;
    
    my $string = $result[0];
    if( $result[0] != 1) {
		$string.= " days ";
	}
	else {
		$string.=" day ";
	}
	$string .= $result[1];
	if( $result[1] != 1) {
		$string .= " hours ";
	}
	else {
		$string .= " hour";
	}
	$string .= $result[2];
	if( $result[2] != 1) {
		$string .= " minutes ";
	}
	else {
		$string .= " minute ";
	}
	$string .= $result[3];
	if( $result[3] != 1) {
		$string .=" seconds";
	}
	else {
		$string .= " second";
	}
    return $string;
}
sub get_action_for {
    my $action = shift;
    return '+' if $action =~ /^(\+|plus|from|in|add|after)$/i;
    return '-' if $action =~ /^(\-|minus|ago|subtract|before)$/i;
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
    my ($values1, $values2) = @_;

    my $day = $$values1[0] + $$values2[0];
    my $hour= $$values1[1] + $$values2[1];
    my $min = $$values1[2] + $$values2[2];
    my $sec = $$values1[3] + $$values2[3];

    my $carry = int ($sec / 60);
    $sec = $sec - 60 * $carry;
    $min+= $carry;

    $carry = int($min / 60);
    $min =$min - 60 * $carry;
    $hour += $carry;

    $carry = int($hour/24);
    $hour = $hour - 24 * $carry;
    $day += $carry;  
    
    return format_result($day, $hour, $min, $sec);
}

sub subtract{
	my ($values1, $values2) = @_;

    
    my $sec = $$values1[3] - $$values2[3];
    my $min = $$values1[2] - $$values2[2];
    my $hour= $$values1[1] - $$values2[1];
	my $day = $$values1[0] - $$values2[0];
    
    if($sec < 0){
    	$sec = $sec + 60;
    	$min = $min - 1;
    }
    if($min < 0){
    	$min = $min + 60;
    	$hour = $hour - 1;
    }
    if($hour < 0){
    	$hour = $hour + 24;
    	$day = $day - 1;
    }
    return format_result($day, $hour, $min, $sec);
}

sub get_result {
    my ($values1, $values2, $action) = @_;
    
    return  add (\@$values1, \@$values2) if $action eq '+';
    return subtract (\@$values1, \@$values2) if $action eq '-';
}

handle query_lc => sub {
    my $query = $_;

    return unless $query =~ $full_time_regex;

    my $action = $+{action};
    my $operand1= $+{operand1};
    my $operand2 = $+{operand2};

    my @values1 = get_values($operand1);
    my @values2 = get_values($operand2);
    
    $action = get_action_for($action);

    my $result = get_result (\@values1, \@values2, $action);
    

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
