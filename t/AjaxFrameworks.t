#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => "ajax_frameworks";
zci is_cached   => 1;

my $templates = {
    group => "list",
    options => {
        list_content => "DDH.ajax_frameworks.list_content"
    }
};

my $meta = {
    sourceName => "Wikipedia",
    sourceUrl => "https://en.wikipedia.org/wiki/List_of_Ajax_frameworks"
};

my @javascript_frameworks = (
    "Frameworks for implementation of Ajax using 'javascript'",
    structured_answer => {
        data => ignore(),
        templates => $templates,
        meta => $meta
    }
);

my @java_frameworks = (
    "Frameworks for implementation of Ajax using 'java'",
    structured_answer => {
        data => ignore(),
        templates => $templates,
        meta => $meta
    }
);

my @perl_frameworks = (
    "Framework for implementation of Ajax using 'perl'",
    structured_answer => {
        data => ignore(),
        templates => $templates,
        meta => $meta
    }
);

my @php_frameworks = (
    "Frameworks for implementation of Ajax using 'php'",
    structured_answer => {
        data => ignore(),
        templates => $templates,
        meta => $meta
    }
);

my @python_frameworks = (
    "Framework for implementation of Ajax using 'python'",
    structured_answer => {
        data => ignore(),
        templates => $templates,
        meta => $meta
    }
);

my @ruby_frameworks = (
    "Framework for implementation of Ajax using 'ruby'",
    structured_answer => {
        data => ignore(),
        templates => $templates,
        meta => $meta
    }
);

sub build_structured_answer {
    return @_;
}

sub build_test { test_zci(build_structured_answer(@_)) }

ddg_goodie_test(
    [qw( DDG::Goodie::AjaxFrameworks )],

    # JavaScript Frameworks
    'ajax framework javascript' => build_test(@javascript_frameworks),
    'ajax frameworks javascript' => build_test(@javascript_frameworks),
    'ajax javascript framework' => build_test(@javascript_frameworks),
    'ajax javascript frameworks' => build_test(@javascript_frameworks),
    'javascript ajax frameworks' => build_test(@javascript_frameworks),
    'AJAX Javascript Frameworks' => build_test(@javascript_frameworks),
    'ajax framework js' => build_test(@javascript_frameworks),
    'ajax frameworks js' => build_test(@javascript_frameworks),
    'ajax js framework' => build_test(@javascript_frameworks),
    'ajax js frameworks' => build_test(@javascript_frameworks),
    'AJAX JS Frameworks' => build_test(@javascript_frameworks),

    # Java Frameworks
    'ajax framework java' => build_test(@java_frameworks),
    'ajax frameworks java' => build_test(@java_frameworks),
    'ajax java framework' => build_test(@java_frameworks),
    'ajax java frameworks' => build_test(@java_frameworks),
    'java ajax frameworks' => build_test(@java_frameworks),
    'AJAX JAVA Frameworks' => build_test(@java_frameworks),

    # Perl Frameworks
    'ajax framework perl' => build_test(@perl_frameworks),
    'ajax frameworks perl' => build_test(@perl_frameworks),
    'ajax perl framework' => build_test(@perl_frameworks),
    'ajax perl frameworks' => build_test(@perl_frameworks),
    'perl ajax frameworks' => build_test(@perl_frameworks),
    'AJAX PERL Frameworks' => build_test(@perl_frameworks),

    # PHP Frameworks
    'ajax framework php' => build_test(@php_frameworks),
    'ajax frameworks php' => build_test(@php_frameworks),
    'ajax php framework' => build_test(@php_frameworks),
    'ajax php frameworks' => build_test(@php_frameworks),
    'php ajax frameworks' => build_test(@php_frameworks),
    'AJAX PHP Frameworks' => build_test(@php_frameworks),

    # Python Frameworks
    'ajax framework python' => build_test(@python_frameworks),
    'ajax frameworks python' => build_test(@python_frameworks),
    'ajax python framework' => build_test(@python_frameworks),
    'ajax python frameworks' => build_test(@python_frameworks),
    'python ajax frameworks' => build_test(@python_frameworks),
    'AJAX Python Frameworks' => build_test(@python_frameworks),
    'ajax framework py' => build_test(@python_frameworks),
    'ajax frameworks py' => build_test(@python_frameworks),
    'ajax py framework' => build_test(@python_frameworks),
    'ajax py frameworks' => build_test(@python_frameworks),
    'AJAX PY Frameworks' => build_test(@python_frameworks),

    # ruby Frameworks
    'ajax framework ruby' => build_test(@ruby_frameworks),
    'ajax frameworks ruby' => build_test(@ruby_frameworks),
    'ajax ruby framework' => build_test(@ruby_frameworks),
    'ajax ruby frameworks' => build_test(@ruby_frameworks),
    'ruby ajax frameworks' => build_test(@ruby_frameworks),
    'AJAX Ruby Frameworks' => build_test(@ruby_frameworks),

    # Queries which should not show results using this Instant Answer
    'ajax tutorial' => undef,
    'ajax js' => undef,
    'ajax javascript' => undef,
    'ajax json framework' => undef,
    'ajax CSS framework' => undef,
    'ajax framework code' => undef
);

done_testing;
