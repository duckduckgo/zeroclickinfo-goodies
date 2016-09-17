package DDG::Goodie::PregnancyCalculator;

# ABSTRACT: Calculate a due date and, if apprpriate, gestation.


use DDG::Goodie;
use strict;
use DateTime;
with 'DDG::GoodieRole::Dates';

zci answer_type => 'pregnancy_calculator';


# Caching disabled currently. Result depends on the user timezone and will change at midnight.
zci is_cached => 0;

# Triggers - http://docs.duckduckhack.com/walkthroughs/calculation.html#triggers
triggers any => 'last period', 'lmp','last menstrual period';

my $datestring_regex = datestring_regex();
# Handle statement
handle remainder => sub {
    
    return unless $_ =~ qr/^($datestring_regex)$/i;
    return unless my $lmp = parse_datestring_to_date($_);
    my $lmp_display = date_output_string($lmp);
    my $currentdate = DateTime->now(time_zone => _get_timezone());
    my $future = DateTime->compare($lmp,$currentdate); #Is the LMP in the future
    my $sofar = $lmp->delta_days($currentdate);
    my $duedate = date_output_string($lmp->add(days=>280));
    my $title = "";
    my $subtitle = "";
    my $answer = "";
    
#    If the LMP is in the future we can give a projected due date but not say how far through the pregnancy the person is.
    my $termstring="Full term (40 weeks) : $duedate";
    if ( $future == 1 ) {
        $title = $termstring;
        $answer = "Due date (40 weeks) will be $duedate";
    } else {
       my $dayspreg = $sofar->in_units('days');
       my $days = $dayspreg%7;
       my $weeks = int(($dayspreg/7));
       $title = "Currently $weeks weeks + $days days.";
       $subtitle = $termstring;
       $answer = "Pregnancy currently at $weeks + $days days. Due date (40 weeks) will be $duedate";
    }
    
    
    return $answer,
        structured_answer => {

            id => 'pregnancy_calculator',

            # Name - Used for Answer Bar Tab
            # Value should be chosen from existing Instant Answer topics
            # see http://docs.duckduckhack.com/frontend-reference/display-reference.html#name-string-required
            name => 'Answer',

            data => {
              title => "$title",
              subtitle => "$subtitle",
              description => "Based on last menstrual period of $lmp_display and cycle length of 28 days."
              # image => "http://website.com/image.png"
            },

            meta => {
                sourceUrl => 'https://en.wikipedia.org/wiki/Estimated_date_of_confinement',
                sourceName => 'Wikipedia'
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
