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

has 'regex' => (
    is => 'rw',
    isa => sub { die 'Not a Regexp reference' unless ref $_[0] eq 'Regexp' },
    default => sub { qr// },
);

sub append_to_regex {
    my ($self, $regex) = @_;
    my $new_regex = qr/${$self->regex}$regex/;
    $self->regex($new_regex);
    return $self;
}

sub append_spaced {
    my ($self, $regex) = @_;
    my $new_re;
    $new_re = $self->regex eq qr// ? $regex : qr/ $regex/;
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
    $self->append_to_regex($regex);
}

sub or {
    my ($self, @alternatives) = @_;
    my $regexes = join '|', map { $_->regex } @alternatives;
    $self->append_to_regex(qr/(?:$regexes)/);
}

#######################################################################
#                             Expressions                             #
#######################################################################

my $what_is = qr/what is/i;

sub simple_appender {
    my ($regex, $no_space) = @_;
    return sub {
        my $self = shift;
        $no_space ? $self->append_to_regex($regex)
                  : $self->append_spaced($regex);
    };
}

sub what_is { simple_appender($what_is)->(@_) }

sub question { simple_appender(qr/\??/, 1)->(@_) }

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

1;

__END__
