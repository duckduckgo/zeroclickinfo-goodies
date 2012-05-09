package DDG::Goodie::DateMath;
# ABSTRACT add/subtract days/weeks/months/years to/from a date

use DDG::Goodie;
use Date::Calc qw( Add_Delta_Days Add_Delta_YM This_Year );

triggers any => qw( plus minus + - );
zci is_cached => 1;
zci answer_type => 'date_math';

handle query_lc => sub {
    my @param = split /\s+/;
    return unless scalar @param == 4;

    my ( $date, $action, $number, $unit ) = @param;

    # check/tweak input

    # default to this year:
    my $md_re = '[01]?[0-9]/[0-3]?[0-9]';
    $date .= '/' . This_Year() if $date =~ /^$md_re$/;
    return unless $date =~ /^$md_re\/[0-9]{4}$/;

    my %action_map = (
        plus  => '+',
        '+'   => '+',
        minus => '-',
        '-'   => '-',
    );
    $action = $action_map{$action} || return;

    return unless $number =~ /^\d+$/;
    $number = 0 - $number if $action eq '-';

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

    # output, using original @param
    $param[0] = $date; # include the optional year
    $param[3] = $unit;
    $param[3] .= 's' if $param[2] > 1; # plural?
    return "@param is $answer";
};

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
