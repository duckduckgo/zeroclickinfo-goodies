package DDG::Goodie::ParseCron;
# ABSTRACT: Parsing Crontabs - Show cron events in human-readable form.
# Example input:
#     crontab 42 12 3 Feb Sat
# Example output:
#     at 12:42pm on the 3rd and on Saturday in February
#

use DDG::Goodie;

use strict;
use warnings;
use Try::Tiny;

my @month_names = qw(January February March April May June
    July August September October November December);
my @weekday_names = qw(Sunday Monday Tuesday Wednesday Thursday Friday Saturday Sunday);

my (%month_short_names, %weekday_short_names);

@month_short_names{map substr(lc($_), 0, 3), @month_names} = (1..12);
@weekday_short_names{map substr(lc($_), 0, 3), @weekday_names} = (0..7);

triggers start => 'crontab', 'cron', 'cronjob';

zci is_cached => 0;

# Get ordinal (for days)
sub get_ordinal {
    my $num = shift;
    return $num . 'th' if 11 <= $num % 100 && $num % 100 <= 13;
    return $num . 'rd' if $num % 10 == 3;
    return $num . 'nd' if $num % 10 == 2;
    return $num . 'st' if $num % 10 == 1;
    return $num . 'th';
}

# Get frequency ("every X hours" or "every other day")
sub get_freq {
    my ($freq, $singular, $plural) = @_;
    return "every $singular" if $freq == 1;
    return $freq == 2 ? "every other $singular" : "every $freq $plural";
}

# Join the array with commas and "and"
sub join_list {
    my $last = pop @_;
    return $last if @_ == 0; # one item

    my $out = join(', ', @_);
    $out .= ',' if @_ > 1; # three or more items; add a comma before "and"
    return "$out and $last";
}

# Should it be repeated every day/month/hour/minute
sub is_every {
    my $field = shift;
    return $field eq '*' || $field eq '*/1';
}

sub check_bounds {
    my ($value, $min, $max, $name) = @_;
    die "Invalid $name $value\n" if $value < $min || $value > $max;
}

# Replace a name ("Jan", "Feb", "Sat", "Sun") with the corresponding index
sub replace_names {
    my ($value, $singular, $names) = @_;
    
    # It's not a month or a day of week, but a name is provided
    die "Invalid $singular $value\n" if !defined($names) && $value =~ /[a-z]{3}/i;
    
    # It's a number, no need to search for a name
    return $value if $value !~ /[a-z]{3}/i;
    
    # Name not found
    die "Invalid $singular $value\n" unless exists $names->{lc($value)};
    
    return $names->{lc($value)};
}

# Change x/y into  x,x+y,x+y+y ...
sub fracted_field {
    my ($start, $step, $end) = @_;
    my $temp = "";
    for (my $i = $start; $i < $end; $i += $step) {
        if ($temp ne '') {
            $temp .= ',';
        }
        $temp .= "$i";
    }
    return $temp;  
}

# Parse a field (minute, hour, day, month, or weekday), call format_value for each value, and compose a string
sub parse_field {
    my ($field, $singular, $plural, $min, $max, $format_value, $names) = @_;

    # "every X days" ("*/X" or just "*")
    if ($field =~ m!^\*(?:/(\d+))?$!) {
        check_bounds($1, 1, $max, $singular) if defined $1;
        return get_freq(defined $1 ? $1 : 1, $singular, $plural);
    }
    
    my @components = ();
    my $i = 0;
   
    for (split ',', $field) {
        die "Invalid $singular $_\n" unless $_ =~ m!^(\d+|[a-z]{3})(?:-(\d+|[a-z]{3})(?:/(\d+))?)?$!i;
        my ($start, $stop, $freq) = ($1, $2, $3);
        $start = replace_names($start, $singular, $names);
        $stop = replace_names($stop, $singular, $names) if defined $stop;
        
        my $res = '';
        if (defined $freq) {
            check_bounds($freq, 1, $max, $singular);
            $res .= get_freq($freq, $singular, $plural) . ' ';
        }
        if (defined $stop) { # a range (from X to Y)
            check_bounds($start, $min, $max, $singular);
            check_bounds($stop, $min, $max, $singular);
            
            if ($singular eq 'month' || $singular eq 'day of the week') {
                $res .= &$format_value($start, "start/$i") . ' through ' . &$format_value($stop, "stop/$i");
            } else {
                $res .= 'from ' . &$format_value($start, "start/$i") . ' to ' . &$format_value($stop, "stop/$i");
            }
        } else {
            check_bounds($start, $min, $max, $singular);
            $res .= &$format_value($start, "single/$i");
        }
        $i++;
        push @components, $res;
    }
    return join_list(@components);
}

# An alternative parser that returns an array of all possible values
sub get_all_values {
    my ($field, $singular, $min, $max) = @_;

    my @components = split ',', $field;
    
    if ($field =~ m!^\*(?:/(\d+))?$!) { # "every X days" ("*/X" or just "*")
        if (defined $1) {
            check_bounds($1, 1, $max, $singular);
            return map {$_ * $1 + $min} 0 .. (($max - $min) / $1);
        }
        return $min..$max;
    }
    
    my @values = ();
    for (@components) {
        die "Invalid $singular $_\n" unless $_ =~ m!^(\d+)(?:-(\d+)(?:/(\d+))?)?$!;
        
        check_bounds($3, 1, $max, $singular) if defined $3;
        check_bounds($2, $min, $max, $singular) if defined $2;
        check_bounds($1, $min, $max, $singular) if defined $1;
        
        if (defined $3) { # a range of values with frequency
            push @values, map {$_ * $3 + $1} 0 .. (($2 - $1) / $3);
        } elsif (defined $2) {
            push @values, $1..$2; # a range of values
        } else {
            push @values, $1;
        }
    }
    
    @values = sort {$a <=> $b} @values;
    
    # Remove duplicates
    my %seen;
    return grep {!$seen{$_}++} @values;
}

# Calculate the cartesian product of all possible hours and minutes, if it's not too big
sub get_simple_time {
    my ($minute, $hour) = @_;
    
    my @hours = get_all_values($hour, 'hour', 0, 23);
    my @minutes = get_all_values($minute, 'minute', 0, 59);
    
    return if (scalar(@hours) * scalar(@minutes) > 10); # It's too big
    
    my @times = ();
    for my $hour (@hours) {
        push @times, map {sprintf('%d:%02d%s', $hour % 12 == 0 ? 12 : $hour % 12,
            $_, $hour < 12 ? 'am' : 'pm')} @minutes;
    }
    return 'at ' . join_list(@times);
}

# Parse minute and hour (the first two fields)
sub parse_time {
    my ($minute, $hour) = @_;
    
    # Particular cases
    return 'at midnight' if $minute eq '0' && $hour eq '0';
    
    # x/y minute 
    if ($minute =~ m!^([0-9]|[1-5][0-9])/([0-9]|[1-5][0-9])$!) {
        $minute = fracted_field($1, $2, 60);
    }
    
    # x/y hour 
    if ($hour =~ m!^([0-9]|1[0-9]|2[0-3])/([0-9]|1[0-9]|2[0-3])$!) {
        $hour = fracted_field($1, $2, 24);
    } 
    
    my $out = get_simple_time($minute, $hour);
    return $out if defined $out;
    
    # The common case
    $out = '';
    
    # Parse minutes
    if ($minute =~ /^\d+(?:,\d+)*$/ && $minute ne '0') { # a simple comma-separated list
        my @components = split ',', $minute;
        for (@components) {
            check_bounds($_, 0, 59, 'minute');
        }
        $out .= join_list(@components) . ' ' . ($components[-1] == 1 ? 'minute' : 'minutes') . ' after '
    } elsif ($minute ne '0') {
        $out .= parse_field($minute, 'minute', 'minutes', 0, 59, sub {
            return $_[0] if $_[1] =~ /^start/;
            return $_[0] == 1 ? 'a minute' : "$_[0] minutes";
        });
        # Insert the right preposition
        if ($minute =~ m!^\*(?:/\d+)?$!) { # every X minutes
            return $out if is_every($hour);
            $out .= ' of ';
        } else {
            $out .= ' after ';
        }
    }
    
    # Parse hours
    $out .= parse_field($hour, 'hour', 'hours', 0, 23, sub {
        return ($_[0] % 12 == 0 ? 12 : $_[0] % 12) . ($_[0] < 12 ? 'am' : 'pm');
    });
    return $out;
}

# Parse day, month, and weekday
sub parse_date {
    my ($day, $month, $weekday) = @_;
    
    return 'every day' if (is_every($day) && is_every($month) && is_every($weekday));
    
    # x/y day
    if ($day =~ m!^([1-31])/([1-31])$!) {
        $day = fracted_field($1, $2, 32);
    } 
    
    my $dayres = parse_field($day, 'day', 'days', 1, 31, sub {
        return 'on the ' . get_ordinal($_[0]) if $_[1] eq 'single/0'; # insert the preposition for the first single value
        return get_ordinal($_[0]);
    });
    
    # x/y month
    if ($month =~ m!^([1-12])/([1-12])$!) {
        $month = fracted_field($1, $2, 13);
    }
    
    my $monthres = parse_field($month, 'month', 'months', 1, 12, sub {
        return $month_names[$_[0] - 1];
    }, \%month_short_names);
    
    if (is_every($weekday)) { # No weekday is specified
        return $dayres if is_every($month) && $day =~ m!^\*/\d+$!; # every X days
        return "$dayres of $monthres";
    }
    
    # x/y weekday
    if ($weekday =~ m!^([0-6])/([0-6])$!) {
        $weekday = fracted_field($1, $2, 7);
    }
    
    my $weekres = parse_field($weekday, 'day of the week', 'days of the week', 0, 7, sub {
        return 'on ' . $weekday_names[$_[0]] if $_[1] eq 'single/0';
        return $weekday_names[$_[0]];
    }, \%weekday_short_names);
    
    return "$weekres" . (is_every($month) ? '' : " in $monthres") if is_every($day);
    
    # Both day of week and day of month are specified
    return "$dayres and $weekres" . (is_every($month) ? '' : " in $monthres");
}

# The main function
handle remainder => sub {
    my $line = shift;
    
    my ($minute, $hour, $day, $month, $weekday) = split(' ', $line);
    
    return if (!defined $weekday); # less than five fields
    
    try {
        my $time = parse_time($minute, $hour);
        my $date = parse_date($day, $month, $weekday);

        # If it's something like "every two hours", don't add "every day"
        $time .= ' ' . $date unless $time =~ /^every / && $date eq 'every day';

        return $time, structured_answer => {
            input => [$line],
            operation => 'Crontab',
            result => $time
        };
    } catch {
        return;
    }
    
};
1;
