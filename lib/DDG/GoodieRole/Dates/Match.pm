package DDG::GoodieRole::Dates::Match;
# ABSTRACT: Regular expressions and matching for dates.

use strict;
use warnings;

use File::Find::Rule;
use List::MoreUtils qw( uniq );
use List::Util qw( any );
use Module::Data;
use Path::Class;
use YAML::XS qw(LoadFile);
use DateTime::Locale;
use Regexp::Common qw(pattern);
use Moo;
with 'DDG::GoodieRole::NumberStyler';

BEGIN {
    require Exporter;
    our @ISA = qw(Exporter);
    our @EXPORT = qw(%tz_offsets format_spec_to_regex);
}

my %locale_cache;
sub get_locale {
    my $locale = shift;
    return $locale_cache{$locale} if defined $locale_cache{$locale};
    $locale_cache{$locale} = DateTime::Locale->load($locale);
    return $locale_cache{$locale};
}

sub get_dates_path {
    my $target = 'DDG::GoodieRole::Dates';
    my $moddata = Module::Data->new($target);
    my $basedir = $moddata->root->parent;
    my $dates_location = 'lib/DDG/GoodieRole/Dates';
    if ( -e $basedir->subdir($dates_location))  {
        my $dir = dir($basedir, $dates_location);
        return "$dir";
    }
}

my $dates_path = get_dates_path();

sub _dates_dir {
    my $to_find = shift;
    my @results = File::Find::Rule->name("$to_find")->in($dates_path);
    return $results[0];
}

my $time_formats = LoadFile(_dates_dir('time_formats.yaml'));
my %time_formats = %{$time_formats};

my @standard_formats = map { @{$_->{formats}} } (values %time_formats);

sub _extend_allowed_numerics {
    my $format = shift;
    $format =~ s/%d/%%d/g;
    $format =~ s/%m/%%m/g;
    return $format;
}

sub _ordered_date_formats_locale {
    my ($locale, $use_locale_formats) = @_;
    my @additional_formats;
    if ($locale) {
        my $l = get_locale($locale);
        @additional_formats = $use_locale_formats ? map { _extend_allowed_numerics($_) } (
            $l->glibc_date_format,
            $l->glibc_date_1_format,
            $l->glibc_datetime_format,
        ) : ();
    }
    my @ordered_formats = sort { length $b <=> length $a } (
        @standard_formats, @additional_formats,
    );
    return \@ordered_formats;
}

sub numbers_with_suffix {
    my @numbers = @_;
    my @with_suffix = map {
        $_ =~ /1\d$|[04-9]$/ ? $_ . '\s*th'
            : $_ =~ /2$/ ? $_ . '\s*nd'
            : $_ =~ /3$/ ? $_ . '\s*rd'
            : $_ =~ /1$/ ? $_ . '\s*st'
            : undef;
    } @numbers;
    return qr/(?:@{[join '|', @with_suffix]})/i;
}

my $tz_yaml = LoadFile(_dates_dir('time_zones.yaml'));
our %tz_offsets = %{$tz_yaml};

# Timezones: https://en.wikipedia.org/wiki/List_of_time_zone_abbreviations
sub get_timezones {
    return %tz_offsets;
}

#######################################################################
#                              Patterns                               #
#######################################################################

my %percent_to_spec = (
    '%A' => [qw(date weekday full)],
    '%B' => [qw(date month full)],
    '%D' => [qw(date formatted slash)],
    '%F' => [qw(date formatted full)],
    '%H' => [qw(time hour 24)],
    '%I' => [qw(time hour 12)],
    '%M' => [qw(time minute)],
    '%S' => [qw(time second)],
    '%T' => [qw(time 24)],
    '%Y' => [qw(date year full)],
    '%Z' => [qw(time zone abbrev)],
    '%a' => [qw(date weekday abbrev)],
    '%b' => [qw(date month abbrev)],
    '%c' => [qw(date formatted default)],
    '%d' => [qw(date dom)],
    '%e' => [qw(date dom), q(-pad=>' ')],
    '%m' => [qw(date month)],
    '%p' => [qw(time am_pm)],
    '%r' => [qw(time 12)],
    '%y' => [qw(date year end)],
    '%z' => [qw(time zone offset)],
    '%%D' => [qw(date dom natural)],
    '%%d' => [qw(date dom -pad=>'0?')],
    '%%m' => [qw(date month -pad=>'0?')],
);

# Additional 'global' is -names, which means to provide named
# captures when set.
#
# Use the format (?k<name>...) for named captures using -names.
sub check_keep {
    my ($flags, $regex) = @_;
    # Don't want to get stuck in recursion...
    die "No flags passed" unless defined $flags;

    return sub { check_keep($_[1], $flags) }
        unless defined $regex;

    if (exists $flags->{-names}) {
        $regex =~ s/\Q(?k<\E([^>]*)\Q>/(?<$1>/g;
    } else {
        $regex =~ s/\Q(?k<\E[^>]*\Q>/(?k:/g;
    }

    if (exists $flags->{-keep}) {
        $regex =~ s/\Q(?k:/(/g;
    } else {
        $regex =~ s/\Q(?k:/(?:/g;
    }

    return $regex;
}

sub date_pattern {
    my %options = @_;
    my $create = $options{create};
    $options{create} = ref $create eq 'CODE'
        ? sub { check_keep($_[1], $create->(@_)) }
        : check_keep($create);
    pattern %options;
}


# %H
date_pattern
    name   => [qw(time hour 24)],
    create => qq/(?k<hour>[01][0-9]|2[0-3])/,
    ;

# %I
date_pattern
    name   => [qw(time hour 12 -oclock)],
    create => sub {
        my $use_oclock = $_[1]->{-oclock};
        $use_oclock
            ? qq/(?k:(?k<hour>[1-9]|1[0-2]) ?o'? ?clock)/
            : qq/(?k<hour>0[1-9]|1[0-2])/;
    },
    ;

# %M
date_pattern
    name   => [qw(time minute)],
    create => qq/(?k<minute>[0-5][0-9])/,
    ;

# %S
date_pattern
    name   => [qw(time second)],
    create => qq/(?k<second>[0-5][0-9]|60)/,
    ;

# %T
date_pattern
    name   => [qw(time 24)],
    create => qq/(?k:(?k<hour>$RE{time}{hour}{24}):(?k<minute>$RE{time}{minute}):(?k<second>$RE{time}{second}))/,
    ;

# %p
date_pattern
    name   => [qw(time am_pm -locale=en)],
    create => sub {
        my $flags = $_[1];
        my $locale = $flags->{-locale};
        my $l = get_locale($locale);
        my @am_pm = @{$l->am_pm_abbreviated};
        qq/(?k<am_pm>@{[join '|', @am_pm]})/;
    },
    ;

# %r
# Under keep:
#
# C<$1> <time> is the full time.
# C<$2> is the 12-hour time in HH:MM:SS
# C<$3> <hour> is the hour
# C<$4> <minute> is the minute
# C<$5> <second> is the second
# C<$6> <am_pm> is the AM/PM equivalent
date_pattern
    name   => [qw(time 12)],
    create => format_spec_to_regex(
        qq/(?k<time>(?k:%I:%M:%S) %p)/,
        no_captures => 0,
        no_escape   => 1,
        ignore_case => 1,
    ),
    ;

# %z
# C<$1> is the full time zone.
# C<$2> is the sign.
# C<$3> is the offset in HHMM.
date_pattern
    name => [qw(time zone offset)],
    create => qq/(?k<time_zone>(?k:[+-])(?k:$RE{time}{hour}{24}$RE{time}{minute}))/,
    ;

# %Y
date_pattern
    name   => [qw(date year full)],
    create => qq/(?k<year>[0-9]{4})/,
    ;

# %d
date_pattern
    name   => [qw(date dom -pad=0)],
    create => sub {
        my $flags = $_[1];
        my $pc = $flags->{'-pad'};
        qq/(?k<day_of_month>${pc}[1-9]|[12][0-9]|3[01])/;
    },
    ;

# %%D
date_pattern
    name   => [qw(date dom natural)],
    create => qq/(?k<day_of_month>@{[numbers_with_suffix(1..31)]})/,
    ;

# %m
date_pattern
    name   => [qw(date month -pad=0)],
    create => sub {
        my $pad = $_[1]->{-pad};
        qq/(?k<month>${pad}[1-9]|1[0-2])/;
    },
    ;

# %F
date_pattern
    name   => [qw(date formatted full)],
    create => format_spec_to_regex(
        '(?k:(?k<year>%Y)-(?k<month>%m)-(?k<day_of_month>%d))',
        no_escape => 1,
        no_captures => 1,
    ),
    ;

# %Z
date_pattern
    name   => [qw(time zone abbrev)],
    create => qq/(?k<time_zone>@{[join '|', keys %tz_offsets]})/,
    ;

# %y
date_pattern
    name   => [qw(date year end)],
    create => qq/(?k<year>[0-9]{2})/,
    ;

# %D
#
# Date in the format %m/%d/%y
#
# Under C<-keep>
#
# C<$1> matches the entire date.
# C<$2> matches the month.
# C<$3> matches the day.
# C<$4> matches the year.
date_pattern
    name   => [qw(date formatted slash)],
    create => format_spec_to_regex(
        '(?k:(?k<month>%m)/(?k<day_of_month>%d)/(?k<year>%y))',
        no_escape => 1,
        no_captures => 1,
    ),
    ;

# %a
date_pattern
    name => [qw(date weekday abbrev -locale=en)],
    create => sub {
        my $flags = $_[1];
        my ($locale) = @{$flags} { qw(-locale) };
        my $l = get_locale($locale);
        my @abbreviated_weekdays = @{$l->day_format_abbreviated};
        my $abbr = join '|', @abbreviated_weekdays;
        return qq/(?k<weekday>$abbr)/;
    },
    ;

# %A
date_pattern
    name => [qw(date weekday full -locale=en)],
    create => sub {
        my $flags = $_[1];
        my ($locale) = @{$flags} { qw(-locale) };
        my $l = get_locale($locale);
        my @full_days = @{$l->day_format_wide};
        my $abbr = join '|', @full_days;
        return qq/(?k<weekday>$abbr)/;
    },
    ;

# %b
date_pattern
    name => [qw(date month abbrev -locale=en)],
    create => sub {
        my $flags = $_[1];
        my ($locale) = @{$flags} { qw(-locale) };
        my $l = get_locale($locale);
        my @short_months = uniq (@{$l->month_format_abbreviated}, @{$l->month_stand_alone_abbreviated});
        my $abbr = join '|', @short_months;
        return qq/(?k<month>$abbr)/;
    },
    ;

# %B
date_pattern
    name   => [qw(date month full -locale=en)],
    create => sub {
        my $flags = $_[1];
        my ($locale) = @{$flags} { qw(-locale) };
        my $l = get_locale($locale);
        my @full_months = uniq (@{$l->month_format_wide}, @{$l->month_stand_alone_wide});
        my $abbr = join '|', @full_months;
        return qq/(?k<month>$abbr)/;
    },
    ;

# %c
date_pattern
    name   => [qw(date formatted default -locale=en)],
    create => format_spec_to_regex(
        qq/(?k:%a %b %e %T %Y)/,
        no_escape => 1,
        no_captures => 1,
        locale => $_[1]->{-locale},
    ),
    ;

sub separator_specifier_regex {
    my $format = shift;
    my @formats;
    push @formats, $format =~ s/%%-/-/gr;
    push @formats, $format =~ s|%%-|/|gr;
    push @formats, $format =~ s/%%-/\\./gr;
    push @formats, $format =~ s/%%-/,/gr;
    push @formats, $format =~ s/%%-/_/gr;
    my $seps = join '|', @formats;
    return qr/(?:$seps)/;
}

sub date_format_to_regex {
    my ($self, $format) = @_;
    return format_spec_to_regex(
        $format,
        locale => $self->_locale,
        no_captures => 1,
        ignore_case => 1,
    );
}

sub ptr_to_regex {
    my ($percent, %options) = @_;
    my ($locale, $use_keep, $use_names, $ignore_case)
        = @options { qw(locale keep names ignore_case) };
    my $subs = $percent_to_spec{$percent};
    die "Unknown format: $percent" unless defined $subs;
    my $format = '$RE' . join '', map { "{$_}" } @$subs;
    $format .= "{-locale=>'$locale'}" if $locale;
    $format .= "{-keep}" if $use_keep;
    $format .= "{-names}" if $use_names;
    $format .= "{-i}" if $ignore_case;
    # We know *exactly* what is in format.
    return qq/@{[eval $format]}/;
}

sub format_spec_to_regex {
    my ($spec, %options) = @_;
    my ($locale, $no_captures, $no_escape) =
        @options {qw(locale no_captures no_escape)};
    unless ($no_escape) {
        $spec = quotemeta($spec);
        $spec =~ s/\\( |%|-)/$1/g;
    }
    while ($spec =~ /(%(?:%\w|\w))/g) {
        my $sequence = $1;
        if (my $regex = ptr_to_regex(
                $sequence,
                locale => $locale,
                names  => !$no_captures,
                keep   => !$no_captures,
                ignore_case => $options{ignore_case},
            )) {
            die "Recursive sequence in $sequence" if $regex =~ $sequence;
            $spec =~ s/(?<!%)$sequence/$regex/g;
        } else {
            warn "Unknown format control: $1";
        }
    }
    if ($spec =~ /%%-/) {
        $spec = separator_specifier_regex($spec);
    }
    return undef if $spec =~ /(%(%\w|\w))/;
    return qq/(?:$spec)/;
}

#######################################################################
#                       Formatted Date Strings                        #
#######################################################################

date_pattern
    name   => [qw(date formatted -locale=en)],
    create => sub {
        my $flags = $_[1];
        my ($locale) = @{$flags} { qw(-locale) };
        my $self = shift;
        my @regexes = ();

        foreach my $spec (@{_ordered_date_formats_locale($locale, 1)}) {
            my $re = format_spec_to_regex(
                $spec,
                locale => $locale,
                no_captures => 0,
                ignore_case => 1,
            );
            die "No regex produced from spec: $spec" unless $re;
            if (any { $_ eq $re } @regexes) {
                die "Regex redefined for spec: $spec";
            }
            push @regexes, $re;
        }

        my $returned_regex = join '|', @regexes;
        return qq/(?k:$returned_regex)/;
    },
    ;

#######################################################################
#                    Relative & Descriptive dates                     #
#######################################################################

my $number_re = number_style_regex();
$number_re = qr/(?<num>a|$number_re)/;

sub neuter_regex {
    my $re = shift;
    $re =~ s/\?<\w+>/?:/g;
    return qr/$re/;
}

my $yesterday = qr/yesterday/i;
my $tomorrow = qr/tomorrow/i;
my $today = qr/(?:today)/i;
my $time_now = qr/(?:now)/i;
my $specific_day = qr/(?:$yesterday|$today|$tomorrow)/;

my $unit = qr/(?<unit>second|minute|hour|day|week|month|year)s?/i;
my $neutered_unit = neuter_regex($unit);

my $num_sep = qr/(?:, ?|,? and | )/i;
my $num_unit = qr/(?<num>$number_re|the)\s$unit/i;
my $num_unit_nt = qr/$number_re\s$unit/i;
my $date_amount_modifier = qr/(?<amounts>(?:$num_unit$num_sep)*$num_unit)/i;
my $date_amount_modifier_nt = qr/(?<amounts>(?:$num_unit_nt$num_sep)*$num_unit_nt)/i;

my $forward_direction = qr/(?:next|upcoming)/i;
my $backward_direction = qr/(?:previous|last)/i;
my $static_direction = qr/(?:this|current)/i;

my $direction = qr/(?:$forward_direction|$backward_direction|$static_direction)/i;

my $next_last = qr/(?<dir>$direction) $unit/;
my $neutered_next_last = neuter_regex($next_last);

my $ago = qr/ago|previous|before/i;
my $ago_from_now = qr/$date_amount_modifier\s(?<dir>$ago)/;
my $neutered_ago_from_now = neuter_regex($ago_from_now);

my $in_time = qr/in $date_amount_modifier_nt(?:\stime)?/i;
my $neutered_in = neuter_regex($in_time);

# Reused lists and components for below

my $date_number         = qr#[0-3]?[0-9]#;
my $relative_dates      = qr#
    $specific_day |
    $time_now |
    $neutered_next_last |
    $neutered_in |
    $neutered_ago_from_now
#ix;

date_pattern
    name => [qw(date relative)],
    create => $relative_dates,
    ;

my $units = qr/(?<unit>second|minute|hour|day|week|month|year)s?/i;

my $from_re = qr/in $number_re $units/;

date_pattern
    name => [qw(date descriptive -locale=en)],
    create => sub {
        my $locale = $_[1]->{-locale};
        my $month_regex = format_spec_to_regex(
            '%B|%b', no_captures => 0, no_escape => 1,
            ignore_case => 1, locale => $locale,
        );
        my $day_regex = format_spec_to_regex(
            '%%D|%d|%%d', no_captures => 0, no_escape => 1,
            ignore_case => 1, locale => $locale,
        );
        my $year = $RE{date}{year}{full}{-names};
        # Used for parse_descriptive_datestring_to_date
        return qr#
            (?<direction>next|last)\s$month_regex |
            $month_regex\s$year |
            $day_regex\s$month_regex |
            $month_regex\s$day_regex |
            $month_regex |
            (?<r>$relative_dates)
            #ix;
    },
    ;

my $ago_rec = qr/ago|previous to|before/i;
my $from_rec = qr/from|after/i;

my $before_after = qr/$date_amount_modifier\s(?<dir>$ago_rec|$from_rec)\s/i;

date_pattern
    name => [qw(date descriptive full -locale=en)],
    create => sub {
        my $locale = $_[1]->{-locale};
        my $formatted_datestring = $RE{date}{formatted}{-locale=>$locale};
        my $descriptive_datestring = $RE{date}{descriptive}{-locale=>$locale};
        return
            qr#(?<date>(?<r>$before_after)(?<rec>(?&date)|$formatted_datestring)|
            $descriptive_datestring)#xi;
    },
    ;

my $neutered_relative_dates = neuter_regex($relative_dates);
my $neutered_before_after = neuter_regex($before_after);

sub is_relative_datestring {
    my $datestring = shift;
    return 1 if $datestring =~ /$neutered_before_after|$neutered_relative_dates/;
    return 0;
}

1;

__END__
