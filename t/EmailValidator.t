#! /usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'email_validation';
zci is_cached   => 1;

sub build_test {
    my ($answer, $input, $ignore) = @_;
    my $subtitle = $ignore ? ignore() : "Email address validation: $input";
    return test_zci(re($answer), structured_answer => {
        data => {
            title => re($answer),
            subtitle => $subtitle
        },
        templates => {
            group => 'text'
        }
    });
}

my $valid_re = qr/appears to be valid/;

ddg_goodie_test(
    ['DDG::Goodie::EmailValidator'],
    'validate my email foo@example.com' => build_test($valid_re, 'foo@example.com'),
    'validate my email foo+abc@example.com' => build_test($valid_re, 'foo+abc@example.com'),
    'validate my email foo.bar@example.com' => build_test($valid_re, 'foo.bar@example.com'),
    'validate user@exampleaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa.com'
      => build_test(qr/Please check the address/, ignore(), 1),
    'validate foo@example.com' => build_test($valid_re, 'foo@example.com'),
    'validate foo@!!!.com' => build_test(qr/Please check the fully qualified domain name/, 'foo@!!!.com'),
    'validate foo@fo;o.com' => build_test(qr/E-mail address foo\@fo;o\.com is invalid/, 'foo@fo;o.com'),
    'validate foo@example.lmnop' => build_test(qr/Please check the top-level domain/, 'foo@example.lmnop'),
    'validate foo' => undef,
);

done_testing;
