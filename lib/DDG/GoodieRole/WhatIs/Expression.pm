package DDG::GoodieRole::WhatIs::Expression;
# ABSTRACT: Allow building of regular expressions in an intuitive
# manner.

use Moo;

BEGIN {
    require Exporter;

    our @ISA = qw(Exporter);
    our @EXPORT_OK = qw(expr named when_opt);
}

use Symbol qw(qualify_to_ref);

use List::MoreUtils qw(uniq);

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

expression opt => sub {
    my ($self, $option) = @_;
    my $val = $self->options->{$option};
    unless (defined $val) {
        $self->add_req_options($option);
        $self->invalidate();
        return $self;
    } else {
        $self->append_spaced(qr/(?<$option>$val)/);
    }
};

expression prefer_opt => sub {
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
    unless (defined $val) {
        $self->add_req_options(grep { ref $_ ne 'CODE' } @fallbacks);
        $self->invalidate();
        return $self;
    } else {
        $self->append_spaced(qr/(?<$named>$val)/);
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

my $how_to = qr/(?:how (?:(?:(?:do|would) (?:you|I))|to))/i;

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
    my $self = shift;
    my $unit = $self->options->{unit};
    return $self unless defined $unit;
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
        qr/ (?<unit>$symbol)/,
        qr/ (?<unit>$word)/,
        qr/(?<unit>$symbol)/
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
