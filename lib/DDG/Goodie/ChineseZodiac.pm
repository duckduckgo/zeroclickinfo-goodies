package DDG::Goodie::ChineseZodiac;
# ABSTRACT: Return the Chinese zodiac animal for a given year.

use strict;
use DDG::Goodie;
with 'DDG::GoodieRole::Dates';
use DateTime::Calendar::Chinese;
use DateTime::Event::Chinese qw(chinese_new_year_before chinese_new_year_after);
use utf8;

triggers any => 'chinese zodiac', 'shēngxiào', 'shengxiao', 'shēng xiào', 'sheng xiao';
zci is_cached => 0;

my %animal_attributes = (
    'hare' => { en => 'Rabbit', zh => '兔' , icon => "rabbit.png", class => "bg-clr--wood"},
    'dragon' => { en => 'Dragon', zh => '龙' , icon => "dragon.png", class => "bg-clr--green"},
    'snake' => { en => 'Snake', zh => '蛇' , icon => "snake.png", class => "bg-clr--red"},
    'horse' => { en => 'Horse', zh => '马' , icon => "horse.png", class => "bg-clr--red"},
    'sheep' => { en => 'Goat', zh => '羊' , icon => "goat.png", class => "bg-clr--green"},
    'monkey' => { en => 'Monkey', zh => '猴' , icon => "monkey.png", class => "bg-clr--grey"},
    'fowl' => { en => 'Rooster', zh => '鸡' , icon => "rooster.png", class => "bg-clr--grey"},
    'dog' => { en => 'Dog', zh => '狗' , icon => "dog.png", class => "bg-clr--green"},
    'pig' => { en => 'Pig', zh => '猪' , icon => "pig.png", class => "bg-clr--blue-light"},
    'rat' => { en => 'Rat', zh => '鼠' , icon => "rat.png", class => "bg-clr--blue-light"},
    'ox' => { en => 'Ox', zh => '牛' , icon => "ox.png", class => "bg-clr--green"},
    'tiger' => { en => 'Tiger', zh => '虎' , icon => "tiger.png", class => "bg-clr--wood"}
);

my $goodie_version               = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;
my $chinese_zodiac_tz            = 'Asia/Shanghai';
my $descriptive_datestring_regex = descriptive_datestring_regex();
my $formatted_datestring_regex   = formatted_datestring_regex();

handle remainder => sub {

    #Figure out what date the user is interested in
    my $date_gregorian;

    if (/^$formatted_datestring_regex$/) {
        # First look for a fully specified string
        $date_gregorian = parse_formatted_datestring_to_date($_);
    } elsif (/\b(\d+)\b/) {
        # Now check for bare years, as we prefer a different start time than the role.
        $date_gregorian = DateTime->new(year  => $1, month => 6,);
    } elsif (/^($descriptive_datestring_regex)([']?[sS]?)$/) {
        # Now use the role to look for more vague date suggestions
        $date_gregorian = parse_descriptive_datestring_to_date($1);
    } elsif (/(what|which|animal|current)/) {
        #Otherwise, default to now if it seems like the user is
        # asking a question about the current zodiac animal
        $date_gregorian = DateTime->now();
    }

    #Don't want to show instant answer if user is just looking for
    # general information on the chinese zodiac
    return unless $date_gregorian;
    $date_gregorian->set_time_zone($chinese_zodiac_tz);
    #DateTime::Event::SolarTerm only supports 1900--2069, so
    # return nothing if the user provides a year outside this range
    return unless $date_gregorian->year >= 1900 && $date_gregorian->year <= 2069;

    #Find the Chinese year that aligns
    # with the query (presumed Gregorian) year
    my $year_chinese = DateTime::Calendar::Chinese->from_object(object => $date_gregorian);

    #Get the inclusive Gregorian date range for the Chinese year
    #Note that returned dates will be for the 'Asia/Shanghai'
    # time zone (China Standard Time/CST) as this is where
    # Chinese New Year is calculated
    my $year_start = chinese_new_year_before($date_gregorian->add(days => 1))->set_time_zone($chinese_zodiac_tz);
    my $year_end = chinese_new_year_after($date_gregorian)->subtract(days => 1)->set_time_zone($chinese_zodiac_tz);

    my $statement = $year_start->strftime("%b %d, %Y") . " – " . $year_end->strftime("%b %d, %Y");

    return format_answer($statement, $year_chinese->zodiac_animal);
};

sub format_answer {
    my ($statement, $animal) = @_;
    my $attributes = $animal_attributes{$animal};

    my $english = $attributes->{'en'};
    my $character = $attributes->{'zh'};
    my $path = "/share/goodie/chinese_zodiac/$goodie_version/$attributes->{'icon'}";
    my $class = $attributes->{'class'};

    return "$character ($english)", structured_answer => {
        data => {
            title => "$character ($english)",
            subtitle => $statement,
            image => $path,
            url => "https://en.wikipedia.org/wiki/$english\_(zodiac)"
        },
        templates => {
            group => "icon",
            item => 0,
            moreAt => 1,
            variants => {
                iconTitle => 'large',
                iconImage => 'large'
            },
            elClass => {
                iconImage => "$class circle"
            }
        },
        meta => {
            sourceName => "Wikipedia",
            sourceUrl => "https://en.wikipedia.org/wiki/Chinese_zodiac"
        }
    }
}

1;
