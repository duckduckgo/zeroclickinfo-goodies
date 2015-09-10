#!/usr/bin/env perl
use strict;
use warnings;
use open ':std', ':encoding(utf8)';
use Test::More;
use HTTP::Tiny;
use JSON;
use IO::All;
use Data::Dumper;

my $json_dir = "../share/goodie/cheat_sheets/json";
my $json;

foreach my $path (glob("$json_dir/*.json")){
    next if $ARGV[0] && $path ne  "$json_dir/$ARGV[0].json";

    my ($name) = $path =~ /.+\/(.+).json$/;

    subtest 'file' => sub {
      ok my $content < io($path), 'file content can be read';
      ok $json = decode_json($content), 'content is valid JSON';
    };
    
    subtest 'headers' => sub {
      ok exists $json->{id} && $json->{id}, 'has id';
      ok exists $json->{name} && $json->{name}, 'has name';
      ok exists $json->{description} && $json->{description}, 'has description';
    };
    
    subtest 'metadata' => sub {
      my $has_meta = exists $json->{metadata};
      SKIP: {
        skip 'metadata is missing, this is options but suggested to have', 1 unless $has_meta;
        ok exists $json->{metadata}{sourceName}, "has metadata sourceName $name";
        ok exists $json->{metadata}{sourceUrl}, "has metadata sourceUrl $name";
        ok my $url = $json->{metadata}{sourceUrl}, "sourceUrl is not undef $name";
        
            SKIP: {
                skip 'sourceUrl is missing, unable to check it', 1 unless $url;
                ok(HTTP::Tiny->new->get($url)->{success}, 'fetch sourceUrl');
            };
        };
    };
    
    subtest 'sections' => sub {
      ok my $order = $json->{section_order}, 'has section_order';
      is ref $order, 'ARRAY', 'section_order is an array of section names';
    
      # we're going to handle section case mismatches on frontend
      $_ = lc for @$order;
    
      ok my $sections = $json->{sections}, 'has sections';
      is ref $sections, 'HASH', 'sections is a hash of section key/pairs';
    
       map{ 
         $sections->{lc$_} = $sections->{$_}; 
         delete $sections->{$_};
       } keys $sections;
      
      for my $section_name (@$order)
      {
        ok my $section = $sections->{$section_name}, "'$section_name' exists in sections from $name";
      }
    
      for my $section_name (keys %$sections)
      {
        ok grep(/\Q$section_name\E/, @$order), "'$section_name' exists in section_order from $name";
        is ref $sections->{$section_name}, 'ARRAY', "'$section_name' is an array from $name";
    
        my $entry_count = 0;
        for my $entry (@{$sections->{$section_name}})
        {
          ok exists $entry->{key}, "'$section_name' entry: $entry_count has a key from $name";
          #ok exists $entry->{val}, "'$section_name' entry: $entry_count has a val from $name";
          $entry_count++;
        }
      }
    }; 

    subtest 'style' => sub {
      my $sections = $json->{sections};
    
      for my $section_name (keys %$sections)
      {
        for my $entry (@{$sections->{$section_name}})
        {

         # spacing in keys ([a]/[b])'
         if($entry->{val}){
             if($entry->{val} =~ /\(\s\[.+\]\s\/\s\[.+\]\)/g){
                is $entry->{val} =~ /\(\s\[.+\]\s\/\s\[.+\]\)/,  1,  "keys ([a]/[b]) shouldn't have white spaces: $entry->{val} from  $name";
            }
            # trailing white space
            is $entry->{val} =~ /\s"$/, '', "No trailing white space in the value: $entry->{val} from: $name";
            is $entry->{key} =~ /\s"$/, '', "No trailing white space in the key: $entry->{key} from: $name";
        }

        }
      }
    };
}
done_testing;
