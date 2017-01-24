package DDG::Goodie::Calculator::Parser;
# Contains the grammar and parsing actions used by the Calculator Goodie.

BEGIN {
    require Exporter;

    our @ISA    = qw(Exporter);
    our @EXPORT = qw(get_parse_results
                     generate_grammar);
}

use strict;
use warnings;
use utf8;

use Marpa::R2;
use Math::Cephes qw(exp floor ceil);
use Math::Cephes qw(:hypers);
use Math::Cephes qw(asin acos atan);
use DDG::Goodie::Calculator::Result;
use DDG::Goodie::Calculator::Parser::Grammar;
use Moo;
use Regexp::Common;

my @grammars;
sub new_branch {
    my $new_grammar = new_sub_grammar @_;
    push @grammars, $new_grammar;
    return $new_grammar;
}
my $unary_function_grammar = new_branch {
    name => "GenUnaryFunction",
    spec => sub { ["($_[0])", 'Argument'] },
};

my $word_constant_grammar = new_branch {
    name        => "WordConstant",
    spec        => sub { ["($_[0])"] },
    ignore_case => 1,
};

my $symbol_constant_grammar = new_branch {
    name        => "SymbolConstant",
    spec        => sub { ["($_[0])"] },
    ignore_case => 1,
};

my $binary_function_grammar = new_branch {
    name => "GenBinaryFunction",
    spec => sub {
        [ "($_[0])", "('(')", 'Expression',
          "(';')", 'Expression', "(')')",
        ] }
};

my $postfix_factor_modifier_grammar = new_branch {
    name        => "GenPostfixFactorModifier",
    spec        => sub { [ 'FactorFun', "($_[0])" ] },
    ignore_case => 1,
};
my $postfix_func_modifier_grammar = new_branch {
    name        => "GenPostfixFunctionModifier",
    spec        => sub { [ 'Function', "($_[0])" ] },
    ignore_case => 1,
};

my $expression_operator_grammar = new_branch {
    name => "GenExprOp",
    spec => sub { ['Expression', "($_[0])", 'Expression'] }
};

my $term_operator_grammar = new_branch {
    name => "GenTermOp",
    spec => sub { ['Term', "($_[0])", 'Term'] }
};

my $factor_term_operator_grammar = new_branch({
    name => "GenFactorTermOp",
    spec => sub { ['Factor', "($_[0])", 'Term'] }
});

sub new_fraction { Math::BigRat->new(@_) };


sub doit {
    my ($name, $sub) = @_;
    my $full_name = 'DDG::Goodie::Calculator::Parser::' . $name . '::doit';
    no strict 'refs';
    *$full_name = *{uc $full_name} = $sub;
}

sub show {
    my ($name, $sub) = @_;
    my $full_name = 'DDG::Goodie::Calculator::Parser::' . $name . '::show';
    no strict 'refs';
    *$full_name = *{uc $full_name} = $sub;
}
sub new_base {
    my $term = shift;
    doit $term->{name}, $term->{doit};
    show $term->{name}, $term->{show};
}

# Usage: binary_doit NAME, SUB
# SUB should take 2 arguments and return the result of the action.
sub binary_doit {
    my ($name, $sub) = @_;
    doit $name, sub {
        my $self = shift;
        return $sub->($self->[0]->doit(), $self->[1]->doit());
    };
}


sub binary_show {
    my ($name, $sub) = @_;
    show $name, sub {
        my $self = shift;
        return $sub->($self->[0]->show(), $self->[1]->show());
    };
}
sub new_binary {
    my ($name, $doit, $show) = @_;
    binary_doit $name, $doit;
    binary_show $name, $show;
}

sub unary_doit {
    my ($name, $sub) = @_;
    no strict 'refs';
    doit $name, sub {
        my $self = shift;
        return $sub->($self->[0]->doit());
    };
}

my $paren_re = $RE{balanced}{-begin=>'(('}{-end=>'))'};
sub normalize_parens {
    my $text = shift;
    while ($text =~ /$paren_re/g) {
        $text =~ s/\((\([^)]*\))\)/$1/;
    }
    return $text;
}

sub unary_show {
    my ($name, $sub) = @_;
    show $name, sub {
        my $self = shift;
        return normalize_parens $sub->($self->[0]->show());
    };
}
sub new_unary {
    my ($name, $doit, $show) = @_;
    unary_doit $name, $doit;
    unary_show $name, $show;
}

sub new_unary_misc {
    my $term = shift;
    unary_doit $term->{name}, $term->{doit};
    unary_show $term->{name}, $term->{show};
}
new_unary_misc {
    name => 'paren',
    doit => sub { $_[0] },
    show => sub { "($_[0])" },
};
new_unary_misc {
    name => 'primary',
    doit => sub { $_[0] },
    show => sub { $_[0] },
};

# Integers, decimals etc...
sub new_base_value {
    my $term = shift;
    doit $term->{name}, sub { wrap_exact($_[0]->[0]->[2]) };
    show $term->{name}, sub { "$_[0]->[0]->[2]" };
}

new_base_value { name => 'integer' };
new_base_value { name => 'decimal' };

new_base {
    name => 'prefix_currency',
    doit => sub { $_[0]->[1]->doit() },
    show => sub {
        my $self = shift;
        # Things like $5.00, &pound.75
        return $self->[0] . sprintf('%0.2f', $self->[1]->show());
    },
};
new_unary_misc {
    name => 'angle_degrees',
    doit => sub { $_[0]->make_degrees() },
    show => sub { "$_[0]°" },
};
new_unary_misc {
    name => 'angle_radians',
    doit => sub { $_[0]->make_radians() },
    show => sub { "$_[0] ㎭" },
};

sub new_postfix_factor_modifier {
    my $term = shift;
    $postfix_factor_modifier_grammar->add_term($term);
    new_unary_misc {
        name => $term->{name},
        doit => $term->{action},
        show => sub { "$_[0]" . $term->{rep} },
    };
}
sub new_postfix_func_modifier {
    my $term = shift;
    $postfix_func_modifier_grammar->add_term($term);
    new_unary_misc {
        name => $term->{name},
        doit => $term->{action},
        show => sub { "$_[0]" . $term->{rep} },
    };
}

sub optional_prefix {
    my ($opt_prefix, $to_prefix) = @_;
    my @with_prefixes;
    foreach my $tp (@$to_prefix) {
        foreach my $op (@$opt_prefix) {
            push @with_prefixes, ($op . $tp);
        };
    };
    push @with_prefixes, @$to_prefix;
    return \@with_prefixes;
}

new_postfix_factor_modifier {
    rep    => ' squared',
    forms  => 'squared',
    action => sub { $_[0] * $_[0] },
};

new_postfix_factor_modifier {
    rep    => '!',
    action => \&calculate_factorial,
    forms  => ['!', 'factorial'],
};

new_postfix_func_modifier {
    rep    => ' in degrees',
    forms  => ['in degrees'],
    action => sub { return unless $_[0]->declares('angle'); $_[0]->to_degrees() },
};
new_postfix_func_modifier {
    rep    => ' in radians',
    forms  => ['in radians'],
    action => sub { return unless $_[0]->declares('angle'); $_[0]->to_radians() },
};


sub new_binary_misc {
    my $term = shift;
    new_binary $term->{name}, $term->{doit}, $term->{show};
}

new_binary_misc {
    name => 'factored_word_constant',
    doit => sub { $_[0] * $_[1] },
    show => sub { "$_[0] $_[1]" },
};
new_binary_misc {
    name => 'factored_symbol_constant',
    doit => sub { $_[0] * $_[1] },
    show => sub { "$_[0]$_[1]" },
};
new_binary_misc {
    name => 'factored_function',
    doit => sub { $_[0] * $_[1] },
    show => sub { "$_[0] × $_[1]" },
};

sub grammar_term_gen {
    my ($bsub, $grammar_hash, $show_sub_gen) = @_;
    return sub {
        my $term = shift;
        $grammar_hash->add_term($term);
        my $doit = $term->{action};
        my $show = $show_sub_gen->($term->{rep});
        $bsub->($term->{name}, $doit, $show);
    };
}

sub function_gen {
    my $shower = sub { my $rep = shift; return sub { "$rep(@{[join '; ', @_]})" }; };
    return grammar_term_gen(@_, $shower);
}

sub new_unary_function  { function_gen(
    \&new_unary, $unary_function_grammar)->(@_) };

sub new_binary_function { function_gen(
    \&new_binary, $binary_function_grammar)->(@_) };

new_binary_function {
    rep    => 'mod',
    forms  => ['mod'],
    action => sub { $_[0] % $_[1] },
};


# Result should not be displayed as a fraction if result a long decimal.
sub new_unary_bounded {
    my $unary = shift;
    new_unary_function $unary;
}

my $PI = Math::BigRat->new(Math::BigFloat->new(1)->bpi());
sub new_unary_trig {
    my $trig = shift;
    my $action = $trig->{action};
    $trig->{action} = sub {
        if (abs $_[0]->value > 999_999_999) {
            return $action->($_[0] % wrap_approx(2*$PI));
        } else {
            return $action->($_[0]);
        }
    };
    new_unary_bounded $trig;
}

new_unary_trig {
    rep    => 'sin',
    forms  => ['sin', 'sine'],
    action => sub { $_[0]->rsin() },
};
new_unary_trig {
    rep    => 'cos',
    forms  => ['cos', 'cosine'],
    action => sub { $_[0]->rcos() },
};
new_unary_trig {
    rep    => 'sec',
    forms  => ['sec', 'secant'],
    action => sub { wrap_exact(1) / $_[0]->rcos() },
};
new_unary_trig {
    rep    => 'csc',
    forms  => ['csc', 'cosec', 'cosecant'],
    action => sub { wrap_exact(1) / $_[0]->rsin() },
};
new_unary_trig {
    rep    => 'cotan',
    forms  => ['cotan', 'cot', 'cotangent'],
    action => sub { $_[0]->rcos() / $_[0]->rsin() },
};
new_unary_trig {
    rep    => 'tan',
    forms  => ['tan', 'tangent'],
    action => sub { $_[0]->rsin() / $_[0]->rcos() },
};
new_unary_bounded {
    forms  => ['arcsin', 'asin'],
    action => produces_angle(foreign(\&asin), precision => -12),
    rep    => 'arcsin',
};
new_unary_bounded {
    forms  => ['arccos', 'acos'],
    rep    => 'arccos',
    action => produces_angle(foreign(\&acos, precision => -12)),
};
new_unary_bounded {
    forms  => ['arctan', 'atan'],
    action => produces_angle(foreign(\&atan, precision => -12)),
    rep    => 'arctan',
};

new_unary_function {
    rep    => 'floor',
    action => foreign(\&floor),
};
new_unary_function {
    rep    => 'ceil',
    forms  => ['ceil', 'ceiling'],
    action => foreign(\&ceil),
};


# Hyperbolic functions
new_unary_bounded {
    rep    => 'sinh',
    action => sub { $_[0]->sinh() },
};
new_unary_bounded {
    rep    => 'cosh',
    action => sub { $_[0]->cosh() },
};
new_unary_bounded {
    rep    => 'tanh',
    action => sub { $_[0]->tanh() },
};
new_unary_bounded {
    rep    => 'artanh',
    forms  => ['artanh', 'atanh'],
    action => produces_angle(sub { $_[0]->atanh }),
};
new_unary_bounded {
    forms  => ['arcosh', 'acosh'],
    rep    => 'arcosh',
    action => produces_angle(sub { $_[0]->acosh }),
};
new_unary_bounded {
    forms  => ['arsinh', 'asinh'],
    rep    => 'arsinh',
    action => produces_angle(sub { $_[0]->asinh }),
};

# Log functions
new_unary_function {
    forms  => ['ln', 'log'],
    rep    => 'ln',
    action => sub { log $_[0] },
};

new_binary_misc {
    name => 'logarithm',
    doit => sub { $_[1]->logbase($_[0]) },
    show => sub { "log$_[0]($_[1])" },
};

# Misc functions
new_unary_bounded {
    rep    => 'sqrt',
    forms  => ['sqrt', 'square root', 'square root of'],
    action => sub { sqrt $_[0] },
};

sub calculate_factorial {
    return if $_[0] > wrap_exact(1000); # Much larger than this and I start
                                  # to notice a delay.
    return $_[0]->on_result(sub { $_[0]->bfac() });
}

new_unary_function {
    rep    => 'factorial',
    forms  => ['factorial', 'fact', 'factorial of'],
    action => \&calculate_factorial,
};
new_unary_function {
    rep    => 'exp',
    action => sub { $_[0]->exp_result },
};

sub binary_operator_gen {
    my $grammar_hash = shift;
    my $shower = sub { my $operator = shift; return sub { "$_[0] $operator $_[1]" } };
    return grammar_term_gen(\&new_binary, $grammar_hash, $shower);
}
sub new_expression_operator { binary_operator_gen($expression_operator_grammar)->(@_) }
sub new_term_operator { binary_operator_gen($term_operator_grammar)->(@_) }
sub new_factor_term_operator { binary_operator_gen($factor_term_operator_grammar)->(@_) }

new_expression_operator {
    rep    => '-',
    forms  => ['-', 'take', 'subtract', 'minus'],
    action => sub { $_[0] - $_[1] },
};
new_expression_operator {
    rep    => '+',
    forms  => ['+', 'add', 'plus'],
    action => sub { $_[0] + $_[1] },
};
new_term_operator {
    rep    => '×',
    forms  => ['*', 'times', 'multiplied by'],
    action => sub { $_[0] * $_[1] },
};
new_term_operator {
    rep    => '/',
    forms  => ['/', 'divided by'],
    action => sub { $_[0] / $_[1] },
};
new_term_operator {
    rep    => '%',
    forms  => ['%', 'mod', 'modulo'],
    action => sub { $_[0] % $_[1] },
};

new_factor_term_operator {
    rep    => '^',
    forms  => ['^', 'to the power', 'to the power of'],
    assoc  => 'right',
    action => sub { $_[0] ** $_[1] },
};

new_binary_misc {
    name => 'exp',
    doit => sub { $_[0] * wrap_exact(10) ** $_[1] },
    show => sub { "$_[0] × 10 ^ $_[1]" },
};

sub new_constant {
    my ($constant, $grammar_ref) = @_;
    $grammar_ref->add_term($constant);
    doit $constant->{name}, sub { $constant->{value} };
    show $constant->{name}, sub { $constant->{rep} };
}

sub new_symbol_constant {
    my $constant = shift;
    new_constant $constant, $symbol_constant_grammar;
}
sub new_word_constant {
    my $constant = shift;
    new_constant $constant, $word_constant_grammar;
}

my $big_pi = Math::BigFloat->bpi();
my $big_e = $DDG::Goodie::Calculator::Result::euler;

# Constants go here.
new_symbol_constant {
    forms => 'pi',
    rep   => 'π',
    value => wrap_approx($big_pi),
};
new_symbol_constant {
    forms => ['tau'],
    rep   => 'τ',
    value => wrap_approx(2 * $big_pi),
};
new_word_constant {
    rep   => 'dozen',
    value => wrap_exact(12),
};
new_symbol_constant {
    rep   => 'e',
    value => wrap_approx($big_e),
};
new_word_constant {
    rep   => 'score',
    value => wrap_exact(20),
};

sub generate_grammar {
    my $initial_grammar_text = shift;
    my @generated_grammars = map { $_->generate_sub_grammar() } @grammars;
    my $grammar_text = join "\n", ($initial_grammar_text, @generated_grammars);
    my $grammar = Marpa::R2::Scanless::G->new(
        {   bless_package => 'DDG::Goodie::Calculator::Parser',
            source        => \$grammar_text,
        }
    );
}

sub get_parse {
  my ($recce, $input) = @_;
  eval { $recce->read(\$input) } or return undef;
  return $recce->value();
}


sub get_parse_results {
    my ($grammar, $to_compute) = @_;
    my $recce = Marpa::R2::Scanless::R->new(
        { grammar => $grammar,
        } );
    my $parsed = get_parse($recce, $to_compute) or return;
    my $generated_input = ${$parsed}->show();
    my $val_result = ${$parsed}->doit();
    return unless defined $val_result->value();
    return ($generated_input, $val_result);
}

1;
