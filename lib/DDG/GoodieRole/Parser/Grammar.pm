package DDG::GoodieRole::Parser::Grammar;
# Defines functions for generating entire grammars.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
    our @EXPORT = qw(new_grammar initialize);
}


use Moose;
use namespace::autoclean;

use Marpa::R2;

use DDG::GoodieRole::Parser::Grammar::SubGrammar;

has 'start' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'sub_grammars' => (
    is       => 'ro',
    isa      => 'ArrayRef[DDG::GoodieRole::Parser::Grammar::SubGrammar]',
    required => 1,
);

has 'package' => (
    is       => 'ro',
    isa      => 'Str',
    required => 1,
);

has 'marpa_grammar' => (
    is  => 'ro',
    isa => 'Marpa::R2::Scanless::G',
);

has 'actions' => (
    is       => 'ro',
    isa      => 'ArrayRef[Str]',
    required => 1,
);

my $start_header = <<'END_OF_HEADER';
:default ::= action => [value]
lexeme default = action => [ start, length, value ]
    bless => ::name latm => 1

END_OF_HEADER


sub initialize {
    my $self = shift;
    my $grammar_text = $start_header;
    $grammar_text .= "\n:start ::= @{[$self->start]}\n";

    foreach my $sub_grammar (@{$self->sub_grammars}) {
        $grammar_text .= "\n" . $sub_grammar->generate_sub_grammar();
        $sub_grammar->generate_actions($self->package);
    };
    my $grammar = Marpa::R2::Scanless::G->new({
        bless_package => $self->package,
        source        => \$grammar_text,
    }) or return;
    $self->{marpa_grammar} = $grammar;
    1;
}

sub get_results {
    my ($self, $text) = @_;
    my $recce = Marpa::R2::Scanless::R->new({
        grammar => $self->marpa_grammar,
    });
    eval { $recce->read(\$text) } or return;
    my $value = $recce->value();
    my %result;
    foreach my $action (@{$self->actions}) {
        $result{$action} = ${$value}->$action;
    }
    return %result;
}

__PACKAGE__->meta->make_immutable;

sub new_grammar { DDG::GoodieRole::Parser::Grammar->new(@_) }

1;
