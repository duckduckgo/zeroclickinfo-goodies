#!/usr/bin/env perl

use strict;
use warnings;
use Test::More;
use DDG::Test::Goodie;

zci answer_type => 'jira';
zci is_cached => 1;

ddg_goodie_test(

    [qw( DDG::Goodie::Jira)],
    'ACE-230' => test_zci(
      undef,
      html => qq(ACE (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.)
    ),
    'ace-230' => test_zci(
      undef,
      html => qq(ACE (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/ACE-230">ACE-230</a>.)
    ),
    'jira random AJLIB-230 bug random' => test_zci(
      undef,
      html => qq(ajlib incubator (Codehaus JIRA Bugtracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.)
    ),
    'jira random ajlib-230 bug random' => test_zci(
      undef,
      html => qq(ajlib incubator (Codehaus JIRA Bugtracker): see ticket <a href="https://jira.codehaus.org/browse/AJLIB-230">AJLIB-230</a>.)
    ),
    'SOLR-4530' => test_zci(
      undef,
      html => 'Solr (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/SOLR-4530">SOLR-4530</a>.'
    ),
    'IdentityHtmlMapper solr-4530' => test_zci(
      undef,
      html => 'Solr (Apache JIRA Bugtracker): see ticket <a href="https://issues.apache.org/jira/browse/SOLR-4530">SOLR-4530</a>.'
    ),
);

done_testing;
