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
["https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Flag_of_Australia_(converted).svg/2000px-Flag_of_Australia_(converted).svg.png","Australian Grand Prix","Melbourne","20 March"],
["https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Flag_of_Bahrain.svg/2000px-Flag_of_Bahrain.svg.png","Bahrain Grand Prix","Sakhir","3 April"],
["https://upload.wikimedia.org/wikipedia/commons/thumb/f/fa/Flag_of_the_People's_Republic_of_China.svg/2000px-Flag_of_the_People's_Republic_of_China.svg.png","Chinese Grand Prix","Shanghai","17 April"],
["https://upload.wikimedia.org/wikipedia/en/archive/f/f3/20120812153730!Flag_of_Russia.svg","Russian Grand Prix","Sochi","1 May"],
["https://upload.wikimedia.org/wikipedia/en/thumb/9/9a/Flag_of_Spain.svg/1280px-Flag_of_Spain.svg.png","Spanish Grand Prix","Catalunya","15 May"],
["http://www.worldatlas.com/webimage/flags/countrys/zzzflags/mclarge.gif","Monaco Grand Prix","Monte Carlo","29 May"],
["https://upload.wikimedia.org/wikipedia/en/thumb/c/cf/Flag_of_Canada.svg/1280px-Flag_of_Canada.svg.png","Canadian Grand Prix","Montreal","12 June"],
["https://upload.wikimedia.org/wikipedia/commons/thumb/d/dd/Flag_of_Azerbaijan.svg/2000px-Flag_of_Azerbaijan.svg.png","European Grand Prix","Baku","19 June"],
["https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Flag_of_Austria.svg/2000px-Flag_of_Austria.svg.png","Austrian Grand Prix","Spielberg","3 July"],
["https://upload.wikimedia.org/wikipedia/en/thumb/a/ae/Flag_of_the_United_Kingdom.svg/1280px-Flag_of_the_United_Kingdom.svg.png","British Grand Prix","Silverstone","10 July"],
["https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Flag_of_Hungary.svg/2000px-Flag_of_Hungary.svg.png","Hungarian Grand Prix","Budapest","24 July"],
["https://upload.wikimedia.org/wikipedia/en/thumb/b/ba/Flag_of_Germany.svg/1280px-Flag_of_Germany.svg.png","German Grand Prix","Hockenheim","31 July"],
["http://cdn.wonderfulengineering.com/wp-content/uploads/2015/07/Belgium-Flag-1.gif","Belgian Grand Prix","Spa-Francorchamps","28 August"],
["https://upload.wikimedia.org/wikipedia/en/0/03/Flag_of_Italy.svg","Italian Grand Prix","Monza","4 September"],
["https://upload.wikimedia.org/wikipedia/commons/4/48/Flag_of_Singapore.svg","Singapore Grand Prix","Singapore","18 September"],
["https://upload.wikimedia.org/wikipedia/commons/thumb/6/66/Flag_of_Malaysia.svg/2800px-Flag_of_Malaysia.svg.png","Malaysian Grand Prix","Kuala Lumpur","2 October"],
["https://upload.wikimedia.org/wikipedia/en/thumb/9/9e/Flag_of_Japan.svg/1280px-Flag_of_Japan.svg.png","Japanese Grand Prix","Suzuka","9 October"],
["https://upload.wikimedia.org/wikipedia/en/a/a4/Flag_of_the_United_States.svg","United States Grand Prix","Austin","23 October"],
["https://upload.wikimedia.org/wikipedia/commons/9/9d/Flag_of_Mexico_(reverse).png","Mexican Grand Prix","Mexico City","30 October"],
["https://upload.wikimedia.org/wikipedia/en/thumb/0/05/Flag_of_Brazil.svg/1280px-Flag_of_Brazil.svg.png","Brazilian Grand Prix","Sao Paulo","13 November"],
["https://upload.wikimedia.org/wikipedia/commons/thumb/c/cb/Flag_of_the_United_Arab_Emirates.svg/2000px-Flag_of_the_United_Arab_Emirates.svg.png","Abu Dhabi Grand Prix","Yas Marina","27 November"],
);       
           
             
            my @list = map {gp => $_}, @raceGPList;
    




    
    

    return "plain text response",
        structured_answer => {
            id => 'formula_one_calendar',
            name => 'Answer',

            data => {
                title    => "2016 FORMULA ONE CALENDAR",
                subtitle => "next race in the calendar",
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
