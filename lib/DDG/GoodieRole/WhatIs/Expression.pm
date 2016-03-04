package DDG::GoodieRole::WhatIs::Expression;
# ABSTRACT: Allow building of regular expressions in an intuitive
# manner.

use Moo;

BEGIN {
    require Exporter;

    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(expr named);
}

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

sub regex {
    my $self = shift;
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
    $self->add_to_stack($regex);
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

#######################################################################
#                               Helpers                               #
#######################################################################

sub get_regex {
    my $self = shift;
    return ref $self eq 'DDG::GoodieRole::WhatIs::Expression'
        ? $self->regex
        : $self;
}

sub simple_appender {
    my ($regex, $no_space) = @_;
    return sub {
        my $self = shift;
        $no_space ? $self->append_to_regex($regex)
                  : $self->append_spaced($regex);
    };
}

#######################################################################
#                             Expressions                             #
#######################################################################

#######################################################################
#                               Generic                               #
#######################################################################

sub opt {
    my ($self, $option) = @_;
    my $val = $self->options->{$option};
    unless (defined $val) {
        die "Modifier '@{[$self->options->{_modifier_name}]}' requires the '$option' option to be set";
    }
    $self->append_spaced(qr/(?<$option>$val)/);
}

sub prefer_opt {
    my ($self, @fallbacks) = @_;
    my $named = $fallbacks[0];
    my $val;
    foreach my $fallback (@fallbacks) {
        if (ref $fallback eq 'CODE') {
            last if $val = $fallback->(%{$self->options});
        } else {
            last if $val = $self->options->{$fallback};
        }
    }
    die "Modifier '@{[$self->options->{_modifier_name}]}' requires at least one of the "
        . join(' or ', map { "'$_'" } @fallbacks)
        . " options to be set"
        unless defined $val;
    $self->append_spaced(qr/(?<$named>$val)/);
}

sub re {
    my ($self, $regex) = @_;
    $regex = get_regex($regex);
    $self->append_to_regex($regex);
}

sub or {
    my ($self, @alternatives) = @_;
    my $regexes = join '|', map { get_regex($_) } @alternatives;
    $self->append_to_regex(qr/(?:$regexes)/);
}

sub optional {
    my ($self, $what, $no_space) = @_;
    $what = get_regex($what);
    my $regex = $no_space ? qr/(?:$what)?/ : qr/(?:$what )?/;
    $self->append_spaced($regex);
    $self->is_optional(1);
    return $self;
}

sub maybe_followed_by {
    my ($self, $follower) = @_;
    my $last = $self->pop_stack;
    $self->append_to_regex(qr/(?:$last(?=$follower)$follower|$last)/);
}

sub if_else {
    my ($self, $cond_name, $if, $else) = @_;
    $if   = get_regex($if);
    $else = get_regex($else);
    $self->append_to_regex("(?(<$cond_name>)$if|$else)");
}

sub previous_with_first_matching {
    my ($self, @alternatives) = @_;
    my $last = $self->pop_stack;
    my $alternatives = join '|', map { "$last(?=$_)$_" } @alternatives;
    $self->append_to_regex(qr/(?:$alternatives)/);
}

sub words {
    my ($self, $word) = @_;
    $self->append_spaced($word);
}

#######################################################################
#                              Specific                               #
#######################################################################

#####################
#  Generic Phrases  #
#####################

my $how_to = qr/(?:how (?:(?:(?:do|would) (?:you|I))|to))/i;

sub how_to {
    my ($self, $verb) = @_;
    $self->words($how_to)->words($verb);
}

##############################
#  Directions (Translation)  #
##############################

sub direction {
    my ($self, $direction) = @_;
    $self->words(qr/(?<direction>$direction)/);
}

sub in { direction($_[0], qr/in/i) }

sub to { direction($_[0], qr/to/i) }

sub from { direction($_[0], qr/from/i) }

#################
#  Conversions  #
#################

sub unit {
    my $self = shift;
    my $unit = $self->options->{unit};
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
        qr/(?<unit> $symbol)/,
        qr/(?<unit> $word)/,
        qr/(?<unit>$symbol)/
    );
    return $self;
}

###########
#  Other  #
###########

sub question {
    my $self = shift;
    my $last = $self->pop_stack;
    $self->or(qr/$last\?/, qr/$last/);
}

1;

__END__
