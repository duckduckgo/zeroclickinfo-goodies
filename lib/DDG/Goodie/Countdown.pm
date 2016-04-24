package DDG::Goodie::Countdown;

# ABSTRACT: Provides a countdown to a particular date or time

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use DateTime;

use strict;

zci answer_type => 'countdown';

zci is_cached => 1;

triggers any => 'countdown to','time until','how long until';

my %week_day_to_number = (
    mon => 1,
    tue => 2,
    wed => 3,
    thu => 4,
    fri => 5,
    sat => 6,
    sun => 7    
);

sub get_regex() {
    return (datestring_regex(), relative_dates_regex(), time_12h_regex(), full_day_of_week_regex()."|".short_day_of_week_regex());
}


sub get_initial_difference {
    my $then,my $date,my $time,my $day_of_week, my $days_to_add = 1;
    my $user_input = $_;    
    my ($datestring_regex, $relative_dates_regex, $time_regex, $day_of_week_regex) = get_regex();    
    my $now = DateTime->now(time_zone => _get_timezone());                
    
    #user input a combination of time and date string
    $time = $user_input =~ s/($datestring_regex)//ir;      
    
    #datestring_regex matched somewhere in the input
    if($1) { 
        $then = parse_datestring_to_date($1);                
        $date = $1;   
    } else { 
        #datestring_regex did not match, check if day_of_week_regex matches
        $time = $user_input =~ s/((:?next)?$day_of_week_regex)//ir;             
        if($1) {
         
            $then = DateTime->now(time_zone => _get_timezone());
            $day_of_week = $week_day_to_number{substr(lc $1, 0, 3)};                            
            if($then->day_of_week > $day_of_week || $time =~ /next/) {                
                $day_of_week += 7;
            }            
            $days_to_add = $day_of_week - $then->day_of_week;
            $then->add_duration(DateTime::Duration->new(days => ($days_to_add)));            
            $date = $day_of_week;
        }       
    }
    
    if($time =~ /($time_regex)/) {
       #create date object and change hr,min,sec of $then           
       if(!$then) {            
            $then = DateTime->now(time_zone => _get_timezone());                                 
            $date = $1;
        }
        my ($hours, $minutes, $seconds, $meridiem) = split(/:|[\s]/, $1);
        if($hours == 12) {
            $hours = 0;
        }
        if($meridiem eq 'pm') {
            $hours += 12;
        }            
        if($days_to_add == 0) { 
            if(($then->hour() > $hours || ($then->hour() == $hours and ($then->minute() >= $minutes)))) {                
                $then->add_duration(DateTime::Duration->new(days => 7));                
            }
        }
        elsif(!($date eq 'tomorrow') && $date !~ /^[1-9][0-4]?$/) {
             if($then->hour() > $hours || ($then->hour() == $hours and ($then->minute() >= $minutes))) {                        
                $then->add_duration(DateTime::Duration->new(days => 1));
            }            
        }        
        $then->set_hour($hours);
        $then->set_minute($minutes);
        $then->set_second($seconds);             
    }    
    
    if(!$then || DateTime->compare($then, $now) != 1) {
        return;
    }       
    my $dur = $then->subtract_datetime_absolute($now);               
    my @output = ($dur->in_units( 'nanoseconds' ), date_output_string($then,1));
        
    return @output;
}


# Handle statement
handle remainder => sub {    
                  
    my @output = get_initial_difference($_);            
    
    my $initialDifference = $output[0];    
    
    return unless $initialDifference;  
    
    return $initialDifference,
        structured_answer => {
            data => {
                remainder => $_,
                difference => $initialDifference,
                countdown_to => $output[1]
            },
            templates => {
                group => "text",
            }
        };
};

1;
