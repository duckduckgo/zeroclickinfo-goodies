#!/usr/bin/env perl
use strict;
use warnings;
use open ':std', ':encoding(utf8)';
use Test::More;
use JSON;
use IO::All;

my $json_dir = "share/goodie/cheat_sheets/json";
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
      diag( "description is optional but suggested from $name" ) if !exists $json->{description} && !$json->{description}
    };
    
    subtest 'metadata' => sub {
      my $has_meta = exists $json->{metadata};
      SKIP: {
        skip 'metadata is missing, this is options but suggested to have', 1 unless $has_meta;

        ok exists $json->{metadata}{sourceName}, "has metadata sourceName $name";

        SKIP: {
            skip "sourceUrl is missing from $name", 1 unless exists $json->{metadata}{sourceUrl};
            ok my $url = $json->{metadata}{sourceUrl}, "sourceUrl is not undef $name";
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
        diag( "Missing section $section_name from $name") unless $sections->{$section_name};
      }
    
      for my $section_name (keys %$sections)
      {
        diag( "Missing $section_name in section order for $name") unless grep(/\Q$section_name\E/, @$order);
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

    my $sections = $json->{sections};
    
      for my $section_name (keys %$sections)
      {
        for my $entry (@{$sections->{$section_name}})
        {

         # spacing in keys ([a]/[b])'
         if($entry->{val}){
             if($entry->{val} =~ /\(\s+\[.*\]\s+\/\s+\[.+\]\s+\)/g){
                diag("keys ([a]/[b]) shouldn't have white spaces: $entry->{val} from  $name");
            }
            diag( "No trailing white space in the value: $entry->{val} from: $name") if $entry->{val} =~ /\s"$/;
        }
         if($entry->{key}){
             if($entry->{key} =~ /\(\s+\[.*\]\s+\/\s+\[.+\]\s+\)/g){
                diag("keys ([a]/[b]) shouldn't have white spaces: $entry->{key} from  $name");
            }
            diag( "No trailing white space in the value: $entry->{key} from: $name") if $entry->{key} =~ /\s"$/;
        }
      }
  }
}
done_testing;
