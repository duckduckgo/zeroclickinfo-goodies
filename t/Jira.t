#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'jira';
zci is_cached   => 1;

sub build_test 
{
    my ($html, $ticket_id) = @_;
    return test_zci(undef, structured_answer => {
        data => {
            link => $html,
            input => $ticket_id
        },
        templates => {
            group => 'text'
        }
    });
}

ddg_goodie_test(

    [qw( DDG::Goodie::Jira)],
    'ACE-230' => build_test(
        qq(ACE (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.),
        'ACE-230'
    ),
    'ace-230' => build_test(
        qq(ACE (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.),
        'ACE-230'
    ),
    'jira random AJLIB-230 bug random' => build_test(
        qq(ajlib incubator (Codehaus JIRA Bugtracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.),
        'AJLIB-230'
    ),
    'jira random ajlib-230 bug random' => build_test(
        qq(ajlib incubator (Codehaus JIRA Bugtracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.),
        'AJLIB-230'
    ),
    'SOLR-4530' => build_test(
        'Solr (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/SOLR-4530">SOLR-4530</a>.',
        'SOLR-4530'
    ),
    'IdentityHtmlMapper solr-4530' => build_test(
        'Solr (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/SOLR-4530">SOLR-4530</a>.',
        'SOLR-4530'
    ),
);

done_testing;
