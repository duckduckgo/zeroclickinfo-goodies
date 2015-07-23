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

name 'Chinese Zodiac';
description 'Return the Chinese zodiac animal for a given year';
primary_example_queries 'chinese zodiac for 1969';
secondary_example_queries '2004 chinese zodiac animal', 'what was the chinese zodiac animal in 1992', 'what will the chinese zodiac animal be for 2056', 'last year\'s chinese zodiac';
category 'dates';
topics 'special_interest';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/ChineseZodiac.pm';
attribution github => ['http://github.com/wilkox', 'wilkox'],
            github => ['https://github.com/Sloff', 'Sloff'];

my %animal_to_language_or_image = (
    'hare' => { en => 'Rabbit', zh => '兔', img => 'https://upload.wikimedia.org/wikipedia/commons/2/24/Rabbit.svg' },
    'dragon' => { en => 'Dragon', zh => '龙', img => 'https://upload.wikimedia.org/wikipedia/commons/b/b2/Dragon.svg' },
    'snake' => { en => 'Snake', zh => '蛇', img => 'https://upload.wikimedia.org/wikipedia/commons/1/1d/Snake.svg' },
    'horse' => { en => 'Horse', zh => '马', img => 'https://upload.wikimedia.org/wikipedia/commons/7/76/Horse.svg' },
    'sheep' => { en => 'Goat', zh => '羊', img => 'https://upload.wikimedia.org/wikipedia/commons/2/2d/Goat.svg' },
    'monkey' => { en => 'Monkey', zh => '猴', img => 'https://upload.wikimedia.org/wikipedia/commons/9/96/Monkey_2.svg' },
    'fowl' => { en => 'Rooster', zh => '鸡', img => 'https://upload.wikimedia.org/wikipedia/commons/0/06/Rooster.svg' },
    'dog' => { en => 'Dog', zh => '狗', img => 'https://upload.wikimedia.org/wikipedia/commons/4/4a/Dog_2.svg' },
    'pig' => { en => 'Pig', zh => '猪', img => 'https://upload.wikimedia.org/wikipedia/commons/d/d7/Boar.svg' },
    'rat' => { en => 'Rat', zh => '鼠', img => 'https://upload.wikimedia.org/wikipedia/commons/0/04/Rat.svg' },
    'ox' => { en => 'Ox', zh => '牛', img => 'https://upload.wikimedia.org/wikipedia/commons/d/d1/Oxen.svg' },
    'tiger' => { en => 'Tiger', zh => '虎', img => 'https://upload.wikimedia.org/wikipedia/commons/e/e3/Tiger.svg' }
);

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

    my $animal = $year_chinese->zodiac_animal;
    my $english = $animal_to_language_or_image{$animal}{'en'};
    my $character = $animal_to_language_or_image{$animal}{'zh'};
    my $img = $animal_to_language_or_image{$animal}{'img'};

    my $statement = $year_start->strftime("%b %d, %Y") . " – " . $year_end->strftime("%b %d, %Y");

    return format_answer($character, $english, $statement, $img);
};

sub format_answer {
    my ($character, $english, $statement, $img) = @_;

    return "$character ($english)", structured_answer => {
        id => "chinese_zodiac",
        name => "Chinese Zodiac",
        data => {
            title => "$character ($english)",
            subtitle => $statement,
            url => "https://en.wikipedia.org/wiki/".$english."_(zodiac)",
            image => $img
        },
        templates => {
            group => "icon",
            item => 0,
            moreAt => 1,
            variants => {
                iconTitle => 'large',
                iconImage => 'large'
            }
        },
        meta => {
            sourceName => "Wikipedia",
            sourceUrl => "https://en.wikipedia.org/wiki/Chinese_zodiac"
        }
    }
}

1;
