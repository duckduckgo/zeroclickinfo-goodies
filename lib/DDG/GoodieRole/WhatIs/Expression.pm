package DDG::GoodieRole::WhatIs::Expression;
# ABSTRACT: Allow building of regular expressions in an intuitive
# manner.

use Moo;

BEGIN {
    require Exporter;

    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(expr named when_opt);
    our %EXPORT_TAGS = (
        EXPR => [qw(expr named when_opt)],
    );
}

use Symbol qw(qualify_to_ref);

use List::MoreUtils qw(uniq first_index);
use List::Util qw(first);

#######################################################################
#                               Object                                #
#######################################################################

has 'options' => (
    is => 'ro',
    isa => sub { die 'Not a HASH reference' unless ref $_[0] eq 'HASH' },
);

has 'is_optional' => (
    is      => 'rw',
    default => 0,
);

has '_regex_stack' => (
    is => 'ro',
    isa => sub { die 'Not an ARRAY reference' unless ref $_[0] eq 'ARRAY' },
    default => sub { [] },
);

has 'capture_name' => (
    is => 'ro',
);

has 'is_valid' => (
    is      => 'ro',
    default => 1,
);

has 'req_options' => (
    is      => 'ro',
    isa     => sub { die 'Not an ARRAY reference' unless ref $_[0] eq 'ARRAY' },
    default => sub { [] },
);

sub regex {
    my $self = shift;
    $self->check_options();
    my $re = qr/@{[join '', @{$self->_regex_stack}]}/;
    if (my $name = $self->capture_name) {
        return qr/(?<$name>$re)/;
    }
    return $re;
}

sub add_to_stack {
    my ($self, $regex) = @_;
    my @current = @{$self->_regex_stack};
    push @current, $regex;
    $self->{_regex_stack} = \@current;
}

sub pop_stack {
    my $self = shift;
    pop $self->_regex_stack;
}

sub append_to_regex {
    my ($self, $regex) = @_;
    return $self unless $regex;
    $self->add_to_stack(qr/(?:$regex)/);
    $self->is_optional(0);
    return $self;
}

sub append_spaced {
    my ($self, $regex) = @_;
    return $self unless $regex;
    my $new_re;
    if (!@{$self->_regex_stack} || $self->is_optional) {
        $new_re = $regex;
    } else {
        $new_re = qr/ $regex/;
    }
    $self->append_to_regex($new_re);
}

sub expr {
    my $options = shift;
    if (ref $options eq 'DDG::GoodieRole::WhatIs::Expression') {
        return DDG::GoodieRole::WhatIs::Expression->new(
            options => $options->options
        );
    }
    return DDG::GoodieRole::WhatIs::Expression->new(
        options => $options
    );
}

sub named {
    my ($name, $options) = @_;
    return DDG::GoodieRole::WhatIs::Expression->new(
        options      => $options,
        capture_name => $name,
    );
}

sub when_opt {
    my ($option, $options) = @_;

    my $self = expr($options);
    $self->add_req_options($option);
    unless (defined $options->{$option}) {
        $self->{is_valid} = 0;
    }
    return $self;
}

sub add_req_options {
    my ($self, @options) = @_;
    my @current = @{$self->req_options};
    @current = (@current, @options);
    $self->{req_options} = \@current;
}

sub check_options {
    my $self = shift;
    return $self if $self->is_valid;
    my @req_options = @{$self->req_options};
    my $many = $#req_options;
    die "Modifier '@{[$self->options->{_modifier_name}]}' requires "
    . ($many ? "at least one of the " : "the ")
    . join(' or ', map { "'$_'" } @req_options) . ' option'
    . ($many ? 's ' : ' ') . "to be set";
}

sub invalidate {
    my $self = shift;
    $self->{is_valid} = 0;
}

#######################################################################
#                               Helpers                               #
#######################################################################

sub get_regex {
    my $self = shift;
    return ref $self eq 'DDG::GoodieRole::WhatIs::Expression'
        ? $self->regex
        : $self;
}

sub is_expr {
    my $what = shift;
    return ref $what eq 'DDG::GoodieRole::WhatIs::Expression';
}

sub expression {
    no strict 'refs';
    my $name = qualify_to_ref(shift, qw(DDG::GoodieRole::WhatIs::Expression));
    my $body = shift;
    *{$name} = *{uc $name} = sub {
        my $self = shift;
        return $self unless $self->is_valid;
        $body->($self, @_);
    };
}

#######################################################################
#                             Expressions                             #
#######################################################################

#######################################################################
#                               Generic                               #
#######################################################################

# TODO: Replace this with a better matcher from NumberStyle
my $basic_numeric_regex = qr/\d+(?:\.\d+)?/;

my %option_order = (
    numeric => 1,
    match   => 2,
    unit    => 3,
);
my %option_modifiers = (
    numeric => sub {
        my ($self, $name, $is_numeric) = @_;
        $self->append_spaced(qr/(?<${name}__numeric>$basic_numeric_regex)/)
            if $is_numeric;
    },
    match => sub {
        my ($self, $name, $match) = @_;
        $self->append_spaced(qr/(?<${name}__match>$match)/);
    },
    unit => \&unit,
);

sub _parse_option {
    my ($self, $option_name, $option_value) = @_;
    unless ($option_value->{use_hash}) {
        my $match_re = $option_value->{match};
        return $self->append_spaced(qr/(?<$option_name>$match_re)/);
    }
    my @opts = grep { $_ !~ /^use_hash$/ } keys %$option_value;
    if (my $bad_option = first { not defined $option_order{$_} } @opts) {
        die "Unknown option modifier '$bad_option'";
    }
    my @option_modifiers = sort { $option_order{$a} <=> $option_order{$b} } @opts;
    my $option_expr = named("${option_name}__full_match", $self->options);
    foreach my $option_modifier (@option_modifiers) {
        $option_modifiers{$option_modifier}->(
            $option_expr, $option_name, $option_value->{$option_modifier}
        );
    }
    my $re = $option_expr->regex;
    $self->append_spaced($re);
}

expression opt => sub {
    my ($self, $option) = @_;
    my $val = $self->options->{$option};
    unless (defined $val) {
        $self->add_req_options($option);
        $self->invalidate();
        return $self;
    } else {
        $self->_parse_option($option, $val);
    }
};

expression prefer_opt => sub {
    my ($self, @fallbacks) = @_;
    my $named = ref $fallbacks[0] eq 'ARRAY'
        ? $fallbacks[0]->[0] : $fallbacks[0];
    my $val;
    my @alternatives = ($named);
    foreach my $fallback (@fallbacks) {
        if (ref $fallback eq 'ARRAY') {
            my ($opt, $sub) = @{$fallback};
            $fallback = $opt;
            if (my $v = $self->options->{$opt}) {
                $fallback = $opt;
                last if $val = $sub->($v);
            }
        } else {
            last if $val = $self->options->{$fallback};
        }
        push @alternatives, $fallback;
    }
    unless (defined $val) {
        $self->add_req_options(@alternatives);
        $self->invalidate();
        return $self;
    } else {
        $self->_parse_option($named, $val);
    }
};

expression or => sub {
    my ($self, @alternatives) = @_;
    my @valid_alternatives;
    my @req_options;
    foreach my $alternative (@alternatives) {
        if (is_expr($alternative)) {
            if ($alternative->is_valid) {
                push @valid_alternatives, $alternative->regex;
            } else {
                push @req_options, @{$alternative->req_options};
            }
        } else {
            push @valid_alternatives, $alternative;
        }
    }
    @req_options = uniq @req_options;
    if (@valid_alternatives) {
        my $regexes = join '|', @valid_alternatives;
        $self->append_to_regex(qr/(?:$regexes)/);
    } else {
        $self->add_req_options(@req_options);
        $self->invalidate();
        return $self;
    }
};

expression optional => sub {
    my ($self, $what, $no_space) = @_;
    $what = get_regex($what);
    my $regex = $no_space ? qr/(?:$what)?/ : qr/(?:$what )?/;
    $self->append_spaced($regex);
    $self->is_optional(1);
    return $self;
};

expression maybe_followed_by => sub {
    my ($self, $follower) = @_;
    my $last = $self->pop_stack;
    $self->append_to_regex(qr/(?:$last(?=$follower)$follower|$last)/);
};

expression optional_when_before => sub {
    my ($self, $before, $after, $no_space) = @_;
    $before = get_regex($before);
    $after = get_regex($after);
    my $space = $no_space ? qr// : qr/ /;
    my $re = qr/($before$space$after|$after)/;
    $self->optional($re);
};

expression if_else => sub {
    my ($self, $cond_name, $if, $else) = @_;
    $if   = get_regex($if);
    $else = get_regex($else);
    $self->append_to_regex("(?(<$cond_name>)$if|$else)");
};

expression previous_with_first_matching => sub {
    my ($self, @alternatives) = @_;
    my $last = $self->pop_stack;
    my $alternatives = join '|', map { "$last(?=$_)$_" } @alternatives;
    $self->append_to_regex(qr/(?:$alternatives)/);
};

expression words => sub {
    my ($self, $word) = @_;
    $self->append_spaced($word);
};

expression spaced => sub {
    my $self = shift;
    $self->append_spaced(qr//);
};

#######################################################################
#                              Specific                               #
#######################################################################

#####################
#  Generic Phrases  #
#####################

my $how_to = qr/how (?:(?:(?:do|would) (?:you|I))|to)/i;

expression how_to => sub {
    my ($self, $verb) = @_;
    $self->words($how_to)->words($verb);
};

##############################
#  Directions (Translation)  #
##############################

expression direction => sub {
    my ($self, $direction) = @_;
    $self->words(qr/(?<direction>$direction)/);
};

sub in { direction($_[0], qr/in/i) }

sub to { direction($_[0], qr/to/i) }

sub from { direction($_[0], qr/from/i) }

#################
#  Conversions  #
#################

expression unit => sub {
    my ($self, $name, $unit) = @_;
    my ($symbol, $word);
    if (ref $unit eq 'HASH') {
        $symbol = $unit->{symbol};
        $word = $unit->{word};
        die "unit specified, but neither 'symbol' nor 'word' were specified."
            unless defined ($symbol // $word);
    } else {
        $symbol = $unit;
    };
    $word //= $symbol;
    $self->previous_with_first_matching(
        qr/ (?<${name}__unit>$symbol)/,
        qr/ (?<${name}__unit>$word)/,
        qr/(?<${name}__unit>$symbol)/
    );
    return $self;
};

###########
#  Other  #
###########

expression question => sub {
    my $self = shift;
    my $last = $self->pop_stack;
    $self->or(qr/$last\?/, qr/$last/);
};

1;

__END__
