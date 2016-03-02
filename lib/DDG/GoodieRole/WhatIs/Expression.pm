package DDG::GoodieRole::WhatIs::Expression;
# ABSTRACT: Allow building of regular expressions in an intuitive
# manner.

use Moo;

BEGIN {
    require Exporter;

    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(expr);
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

sub regex {
    my $self = shift;
    return qr/@{[join '', @{$self->_regex_stack}]}/;
}

sub add_to_stack {
    my ($self, $regex) = @_;
    my @current = @{$self->_regex_stack};
    push @current, $regex;
    $self->{_regex_stack} = \@current;
}

sub pop_stack {
    my $self = shift;
    my $popped = pop $self->_regex_stack;
    return $popped;
}

sub append_to_regex {
    my ($self, $regex) = @_;
    $self->add_to_stack($regex);
    $self->is_optional(0);
    return $self;
}

sub append_spaced {
    my ($self, $regex) = @_;
    my $new_re;
    if ($self->regex eq qr// || $self->is_optional) {
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

sub opt {
    my ($self, $option) = @_;
    my $val = $self->options->{$option};
    $self->append_spaced(qr/(?<$option>$val)/);
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

#######################################################################
#                               Helpers                               #
#######################################################################

sub get_regex {
    my $self = shift;
    return ref $self eq 'DDG::GoodieRole::WhatIs::Expression'
        ? $self->regex
        : $self;
}

#######################################################################
#                             Expressions                             #
#######################################################################

#######################################################################
#                               Generic                               #
#######################################################################

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

sub simple_appender {
    my ($regex, $no_space) = @_;
    return sub {
        my $self = shift;
        $no_space ? $self->append_to_regex($regex)
                  : $self->append_spaced($regex);
    };
}

#######################################################################
#                              Specific                               #
#######################################################################

my $what_is = qr/what is/i;

sub what_is { simple_appender($what_is)->(@_) }

sub question {
    my $self = shift;
    my $last = $self->pop_stack;
    $self->or(qr/$last\?/, qr/$last/);
}

sub direction {
    my ($self, $direction) = @_;
    $self->append_spaced(qr/(?<direction>$direction)/);
}

sub in { direction($_[0], qr/in/i) }

sub to { direction($_[0], qr/to/i) }

sub from { direction($_[0], qr/from/i) }

my $how_to = qr/(?:how (?:(?:(?:do|would) (?:you|I))|to))/i;

sub how_to {
    my ($self, $verb) = @_;
    my $re = $how_to;
    $re = qr/$re $verb/ if defined $verb;
    $self->append_spaced($re);
}

sub convert {
    my $self = shift;
    $self->optional(qr/convert/i);
}

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

my $what_are = qr/what (?:is|are)/i;

sub what_are { simple_appender($what_are)->(@_) }

sub singular_or_plural {
    my ($self, $singular, $plural) = @_;
    $self->if_else('_singular', $singular,
        expr($self)->if_else('_plural', $plural, qr/(?:$singular|$plural)/));
}

1;

__END__
