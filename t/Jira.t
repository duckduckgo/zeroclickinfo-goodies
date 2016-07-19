#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use Test::Deep;
use DDG::Test::Goodie;

zci answer_type => 'jira';
zci is_cached   => 1;

sub build_test 
{
    my ($title, $subtitle, $url) = @_;
    return test_zci(undef, structured_answer => {
        data => {
            title => $title,
            subtitle => "JIRA Ticket Lookup: $subtitle",
            url => $url
        },
        templates => {
            group => 'info',
        }
    });
}

ddg_goodie_test(
    [qw( DDG::Goodie::Jira)],
    'ACE-230' => build_test("ACE (Apache JIRA Bugtracker)", 'ACE-230', "https://issues.apache.org/jira/browse/ACE-230"),
    'ace-230' => build_test("ACE (Apache JIRA Bugtracker)", 'ACE-230', "https://issues.apache.org/jira/browse/ACE-230"),
    'jira random AJLIB-230 bug random' => build_test("ajlib incubator (Codehaus JIRA Bugtracker)", 'AJLIB-230', "https://jira.codehaus.org/browse/AJLIB-230"),
    'jira random ajlib-230 bug random' => build_test("ajlib incubator (Codehaus JIRA Bugtracker)", 'AJLIB-230', "https://jira.codehaus.org/browse/AJLIB-230"),
    'SOLR-4530' => build_test("Solr (Apache JIRA Bugtracker)", 'SOLR-4530', "https://issues.apache.org/jira/browse/SOLR-4530"),
    'IdentityHtmlMapper solr-4530' => build_test('Solr (Apache JIRA Bugtracker)', 'SOLR-4530', "https://issues.apache.org/jira/browse/SOLR-4530"),
);

done_testing;
