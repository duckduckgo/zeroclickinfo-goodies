package DDG::Goodie::FormulaOneCalendar;
# ABSTRACT: Write an abstract here

# Start at http://docs.duckduckhack.com/walkthroughs/calculation.html if
# you are new to instant answer development

# WHEN DOING THE PULL REQUEST SAY THAT YOU SAW THIS VIDEO http://docs.duckduckhack.com/walkthroughs/word-count-screencast.html


use DDG::Goodie;
use strict;
use warnings;

zci answer_type => 'formula_one_calendar';

# Caching - http://docs.duckduckhack.com/backend-reference/api-reference.html#caching`
zci is_cached => 1;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => 'formula one calendar', 'formula 1 calendar','f1 calendar', 'f1 schedule','formula 1 schedule','formula one schedule','f1 next race','formula one next race','f1 next race','f1 races';

# Handle statement
handle remainder => sub {
    
    my $remainder = $_;
    
    # Optional - Guard against no remainder
    # I.E. the query is only 'triggerWord' or 'trigger phrase'
    #
    # return unless $remainder;

    # Optional - Regular expression guard
    # Use this approach to ensure the remainder matches a pattern
    # I.E. it only contains letters, or numbers, or contains certain words
    #
    # return unless qr/^\w+|\d{5}$/;

    
    my @words = split " ",$remainder;
    my $count = scalar @words;
    
 #   my @list = map {word => $_}, @words;
my @raceGPList = (
["Australian Grand Prix","Melbourne","20 MARCH"],
["Bahrain Grand Prix","Sakhir","3 APRIL"],
["Chinese Grand Prix","Shanghai","17 APRIL"],
["Russian Grand Prix","Sochi","1 MAY"],
["Spanish Grand Prix","Catalunya","15 MAY"],
["Monaco Grand Prix","Monte Carlo","29 MAY"],
["Canadian Grand Prix","Montreal","12 JUNE"],
["European Grand Prix","Baku","19 JUNE"],
["Austrian Grand Prix","Spielberg","3 JULY"],
["British Grand Prix","Silverstone","10 JULY"],
["Hungarian Grand Prix","Budapest","24 JULY"],
["German Grand Prix","Hockenheim","31 JULY"],
["Belgian Grand Prix","Spa-Francorchamps","28 AUGUST"],
["Italian Grand Prix","Monza","4 SEPTEMBER"],
["Singapore Grand Prix","Singapore","18 SEPTEMBER"],
["Malaysian Grand Prix","Kuala Lumpur","2 OCTOBER"],
["Japanese Grand Prix","Suzuka","9 OCTOBER"],
["United States Grand Prix","Austin","23 OCTOBER"],
["Mexican Grand Prix","Mexico City","30 OCTOBER"],
["Brazilian Grand Prix","Sao Paulo","13 NOVEMBER"],
["Abu Dhabi Grand Prix","Yas Marina","27 NOVEMBER"],
);       
             
             
             
             
             
             
             
             
            my @list = map {gp => $_}, @raceGPList;
    

    
    

    return "plain text response",
        structured_answer => {
            id => 'formula_one_calendar',
            name => 'Answer',

            data => {
                title    => "2016 FORMULA ONE CALENDAR",
                #subtitle => "next race in the calendar",
                # image => "http://website.com/image.png",
                list => \@list,
                #this would be usefull to show only the date of a single race instead of the whole list.
                 
            },

            templates => {
                group => "list",
                 options => {
                    list_content => "DDH.formula_one_calendar.formula_one_calendar"                
                }
            }
        };
};

1;
