package DDG::Goodie::DateMath;
# ABSTRACT add/subtract days/weeks/months/years to/from a date

use DDG::Goodie;
use Date::Calc qw( Add_Delta_Days Add_Delta_YM Decode_Date_US This_Year );
use Lingua::EN::Numericalize;

triggers any => qw( plus minus + - );

zci is_cached => 1;
zci answer_type => 'date_math';

primary_example_queries 'Jan 1 2012 plus 32 days';
secondary_example_queries '1/1/2012 plus 5 months', 'January first minus ten days';
description 'calculate the date with an offset';
name 'DateMath';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/DateMath.pm';
category 'time_sensitive';
topics 'everyday';
attribution github => ['http://github.com/cj01101', 'cj01101'];


handle query_lc => sub {
    my @param = split /\s+/;
    return unless @param >= 4;

    my $unit = pop @param;
    return unless join(' ',@param) =~ qr!^ ([a-z]+ \s ( \d{1,2} | [a-z\s-]+ ) (?:st|nd|rd|th)?,? (?:\s \d{2,4})? |
                                         \d{1,4}/\d{1,4}(?:/\d{1,4})? )
                                         \s(plus|\+|\-|minus)\s(\d+|[a-z\s-]+)$!x;
    my $input_number = str2nbr($4);
    my $input_action = $3;

    my $indate = $1;
    my $innum = $4;
    if ( defined $2 ) {
        $innum = $2;
        my $num = $innum =~ /^\d+$/ ? $innum : str2nbr($innum);
        $indate =~ s/$innum/$num/;
    } 

    my ( $input_date, $date, $date_param_count ) = get_date_info( split(' ',$indate), $input_action, $input_number, $unit );

    # check/tweak other (non-date) input
    my %action_map = (
        plus  => '+',
        '+'   => '+',
        minus => '-',
        '-'   => '-',
    );
    my $action = $action_map{$input_action} || return;

    my $number = $action eq '-' ? 0 - $input_number : $input_number;

    $unit =~ s/s$//g;

    # calculate answer
    my $sub_map = {
        # sub parameters: year, month, day, number
        day => sub {
            return Add_Delta_Days( @_ );
        },
        week => sub {
            $_[3] *= 7; # weeks to days
            return Add_Delta_Days( @_ );
        },
        month => sub {
            $_[4] = $_[3]; # months
            $_[3] = 0;     # 0 years
            return Add_Delta_YM( @_ );
        },
        year => sub {
            push @_, 0; # 0 months
            return Add_Delta_YM( @_ );
        },
    };

    my $sub = $sub_map->{$unit} || return;
    my $answer;
    eval {
        $answer = format_ymd( $sub->( mdy_to_ymd_array( $date ), $number ) );
    };
    return if $@;

    # output
    $unit .= 's' if $input_number > 1; # plural?
    return "$input_date $input_action $input_number $unit is $answer";
};

sub get_date_info
{
    # get the input date and calculated/verified date (m/d/y) from search terms
    my @param = @_;

    # try to figure out what params to use and if to default to the current year
    my @date_param;
    my $date_param_count = 1; # count how many of their words make up the date
    if ( $param[0] =~ /\d+\/\d+/ )
    {
        # 5/1, 5/1/2012
        $param[0] .= '/' . This_Year() unless $param[0] =~ /^\d+\/\d+\/\d+$/;
        @date_param = $param[0];
    }
    elsif ( $param[2] =~ /^\d{4}$/ )
    {
        # May 1 2012
        @date_param = @param[0..2];
        $date_param_count = 3;
    }
    else
    {
        # May 1
        @date_param = ( @param[0..1], This_Year() );
        $date_param_count = 2;
    }

    # is it a date?
    my @ymd = Decode_Date_US( join ' ', @date_param );
    return unless @ymd;

    my $mdy = "$ymd[1]/$ymd[2]/$ymd[0]";

    $date_param[0] = ucfirst $date_param[0]; # in case month is a string
    my $input_date = join ' ', @date_param;  # similar to what they input

    return ( $input_date, $mdy, $date_param_count );
}

sub mdy_to_ymd_array
{
    my @date = split '/', shift;
    return ( $date[2], $date[0], $date[1] );
}

sub format_ymd
{
    # ymd array to m/d/y
    return join '/', $_[1], $_[2], $_[0];
}

1;
