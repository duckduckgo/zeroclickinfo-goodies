#!/usr/bin/env perl
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
      ok exists $json->{metadata}, "has metadata $name";
      ok exists $json->{metadata}{sourceName}, "has metadata sourceName $name";
      ok exists $json->{metadata}{sourceUrl}, "has metadata sourceUrl $name";
      ok my $url = $json->{metadata}{sourceUrl}, "sourceUrl is not undef $name";
    
      SKIP: {
        skip 'sourceUrl is missing, unable to check it', 1 unless $url;
        ok(HTTP::Tiny->new->get($url)->{success}, 'fetch sourceUrl');
      };
    };
    
    subtest 'sections' => sub {
      ok my $order = $json->{section_order}, 'has section_order';
      is ref $order, 'ARRAY', 'section_order is an array of section names';
    
      $_ = lc for @$order;
    
      ok my $sections = $json->{sections}, 'has sections';
      is ref $sections, 'HASH', 'sections is a hash of section key/pairs';
    
      map{ 
        $sections->{lc$_} = $sections->{$_}; 
        delete $sections->{$_};
      } keys $sections;
    
      for my $section_name (@$order)
      {
        ok my $section = $sections->{$section_name}, "'$section_name' exists in sections $name";
      }
    
      for my $section_name (keys %$sections)
      {
        ok grep(/\Q$section_name\E/, @$order), "'$section_name' exists in section_order $name";
        is ref $sections->{$section_name}, 'ARRAY', "'$section_name' is an array $name";
    
        my $entry_count = 0;
        for my $entry (@{$sections->{$section_name}})
        {
          ok exists $entry->{key}, "'$section_name' entry: $entry_count has a key";
          ok exists $entry->{val}, "'$section_name' entry: $entry_count has a val";
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
          if($entry->{val} =~ /\//g){
            is $entry->{val} =~ /\s\/\s/,  1,  "'/' should have spaces $name";
         }
        }
      }
    };
}
done_testing;
