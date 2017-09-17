#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'text_converter';
zci is_cached   => 0;

# Build a structured answer that should match the response from the
# Perl file.
sub build_structured_answer {
    my ($input) = @_;

    return 'plain text response',
        structured_answer => {

            data => {
                title    => 'Text Converter',
                from_type => $input->{'from_type'},
                to_type => $input->{'to_type'}
            },
            templates => {
                group => 'text',
            }
        };
}

# Use this to build expected results for your tests.
sub build_test { test_zci(build_structured_answer(@_)) }

##
#############################################
## TEST CONTENTS
#############################################
##
## 1. GENERIC QUERIES
## 2. LANGUAGE BASED QUERIES
## 3. NO GO QUERIES
##

ddg_goodie_test(
    [qw( DDG::Goodie::TextConverter )],

    ##
    ## 1. GENERIC QUERIES
    ## 

    'binary converter' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'binary',
            to_type => ''
        })
    ),

    'hex converter' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'hexadecimal',
            to_type => ''
        })
    ),

    'ascii converter' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'text',
            to_type => ''
        })
    ),

    'ansi conversion' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => '',
            to_type => 'text'
        })
    ),

    'base64 encoder' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => '',
            to_type => 'base64'
        })
    ),

    'base64 decoder' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'base64',
            to_type => ''
        })
    ),

    'hex translator' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'hexadecimal',
            to_type => ''
        })
    ),

    'binary translation' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => '',
            to_type => 'binary'
        })
    ),

    ##
    ## 2. LANGUAGE BASED QUERIES
    ##

    'hex to ascii' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'hexadecimal',
            to_type => 'text'
        })
    ),

    'binary to text' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'binary',
            to_type => 'text'
        })
    ),

    'binary from text' => test_zci( # should flip if the connecting word is 'from'
        '', structured_answer => build_structured_answer({
            from_type => 'text',
            to_type => 'binary'
        })
    ),

    'text - hex' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'text',
            to_type => 'hexadecimal'
        })
    ),

    'text - hex translation' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'text',
            to_type => 'hexadecimal'
        })
    ),

    'binary to hex translator' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'binary',
            to_type => 'hexadecimal'
        })
    ),

    'translate binary to decimal' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'binary',
            to_type => 'decimal'
        })
    ),

    'convert rot13 to text' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'rot13',
            to_type => 'text'
        })
    ),

    'convert base64 to ansi' => test_zci(
        '', structured_answer => build_structured_answer({
            from_type => 'base64',
            to_type => 'text'
        })
    ),

    ##
    ## 3. NO GO TRIGGERING
    ##

    'bad example query' => undef,
    'how to convert to binary javascript' => undef,
    'binary calculator' => undef,
    'what is ascii binary' => undef,
    'how can I convert to rot13' => undef,
    'what base is hexadecimal' => undef,
);

done_testing;
