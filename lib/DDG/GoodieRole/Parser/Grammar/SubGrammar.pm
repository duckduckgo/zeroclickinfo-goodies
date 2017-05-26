package DDG::GoodieRole::Parser::Grammar::SubGrammar;
# Define Parser sub-grammars.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
    our @EXPORT = qw(new_sub_grammar);
}

use Moose;
use namespace::autoclean;

has spec => (
    is       => 'ro',
    required => 1,
    isa      => 'DDG::GoodieRole::Parser::Spec',
);
has name => (
    is       => 'ro',
    required => 1,
    isa      => 'Str',
);
has terms => (
    is      => 'rw',
    isa     => 'ArrayRef[HashRef]',
    default => sub { [] },
);
has bless_counter => (
    is      => 'ro',
    default => 0,
    isa     => 'Int',
);
has ignore_case => (
    is      => 'ro',
    default => 0,
    isa     => 'Bool',
);
has actions => (
    is      => 'rw',
    isa     => 'HashRef[CodeRef]',
    default => sub { {} },
);

sub generate_sub_grammar {
    my $self = shift;
    my $str_grammar = $self->{name} . " ::= \n";
    warn "No terms for grammar: " . $self->{name} unless @{$self->terms()};
    my ($first_term, @terms) = @{$self->terms()};
    my ($fgl, $frd) = $self->spec->to_grammar(1, $first_term);
    my @alternate_forms = ($frd) if defined $frd;
    $str_grammar .= $fgl;
    foreach my $term (@terms) {
        my ($gl, $rd) = $self->spec->to_grammar(0, $term);
        push @alternate_forms, $rd;
        $str_grammar .= $gl;
    };
    foreach my $alternate_form (@alternate_forms) {
        foreach my $af (@$alternate_form) {
            $str_grammar .= "\n" . $af->{refer_form} . "\n";
        };
    };
    return $str_grammar;
}
sub add_term {
    my ($self, %term) = @_;
    $self->{bless_counter}++;
    $term{name} = ($self->name . $self->bless_counter);
    $term{forms} //= [$term{rep}];
    $term{ignore_case} = $self->ignore_case;
    foreach my $action (keys %{$self->actions}) {
        $term{actions}->{$action} //= $self->actions->{$action}->(%term);
    };
    push @{$self->{terms}}, \%term;
}

sub generate_actions {
    my ($self, $package) = @_;
    foreach my $term (@{$self->terms}) {
        foreach my $action (keys %{$term->{actions}}) {
            my $pname = $package . '::' . $term->{name} . "::$action";
            no strict 'refs';
            *$pname = *{uc $pname} =
                $self->spec->collector($term->{actions}->{$action});
        };
    };
}

__PACKAGE__->meta->make_immutable;

sub new_sub_grammar { DDG::GoodieRole::Parser::Grammar::SubGrammar->new(@_) };

1;
