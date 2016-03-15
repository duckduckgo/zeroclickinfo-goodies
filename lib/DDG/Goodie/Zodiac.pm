package DDG::Goodie::Zodiac;
# ABSTRACT: Find the Zodiac for a given date.

use strict;
use warnings;

use DDG::Goodie;
with 'DDG::GoodieRole::Dates';

use DateTime;
use JSON::MaybeXS;

zci is_cached   => 0;
zci answer_type => "zodiac";

our $zodiac_goodie_version = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION
    // 999;

my @triggers = ('zodiac', 'zodiac sign',
                'starsign', 'star sign');

triggers startend => @triggers;


my $json = share('dates.json')->slurp;
my $decoded = decode_json($json);
my $zodiacs = $decoded->{'zodiacs'};

sub make_zodiac_date {
    my ($year, $date) = @_;
    return DateTime->new(
        day   => $date->[0],
        month => $date->[1],
        year  => $year,
    );
}

sub is_zodiac {
    my ($date, $zodiac) = @_;
    my $zodiac_start = make_zodiac_date($date->year, $zodiac->{start});
    my $zodiac_end = make_zodiac_date($date->year, $zodiac->{end});
    if ($zodiac_end->month == 1) {
        return $date->day <= $zodiac_end->day if $date->month == 1;
        return $date->day >= $zodiac_start->day if $date->month == 12;
    };
    return $zodiac_start <= $date && $date <= $zodiac_end;
}

sub get_zodiac_for {
    my $date = shift;
    foreach my $zodiac (@$zodiacs) {
        return ucfirst($zodiac->{name}) if is_zodiac($date, $zodiac);
    };
}

my @colors = qw(bg-clr--blue-light
                bg-clr--green
                bg-clr--red
                bg-clr--grey);

sub element_sign {
        my $zodiac = shift;
        return $colors[0] if $zodiac =~ /(cancer|scorpius|pisces)/i;
        return $colors[1] if $zodiac =~ /(taurus|virgo|capricornus)/i;
        return $colors[2] if $zodiac =~ /(aries|sagittarius|leo)/i;
        return $colors[3] if $zodiac =~ /(libra|gemini|aquarius)/i;
}

sub get_image {
    my $zodiac = shift;
    my $image_path = "/share/goodie/zodiac/$zodiac_goodie_version/@{[lc($zodiac)]}.png";
    my $icon = "@{[element_sign $zodiac]} circle";
    return ($image_path, $icon);
}

handle remainder => sub {
    my $date_string = $_;
    $date_string =~ s/^\s*(for|on)\s*//;

    my $zodiac_date = parse_datestring_to_date($date_string) or return;

    my $zodiac = get_zodiac_for $zodiac_date or return;
    my $formatted_input = "Zodiac for @{[date_output_string($zodiac_date)]}";
    my ($image_path, $icon) = get_image $zodiac;

    return $zodiac, structured_answer => {
            id   => "zodiac",
            name => "Answer",
            data => {
                image    => $image_path,
                title    => $zodiac,
                subtitle => $formatted_input,
            },
            templates => {
                group   => "icon",
                elClass => {
                    iconImage => $icon,
                },
                variants => {
                     iconImage => 'large'
                }
            }
        };
};

1;
