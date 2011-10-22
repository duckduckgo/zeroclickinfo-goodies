#!/usr/bin/perl

use strict; 
 
# Calculates the Golden Ratio A:B given either A or B.

if ($q_check_lc =~ m/^golden ratio (?:(?:(\?)\s*:\s*(\d+(?:\.\d+)?))|(?:(\d+(?:\.\d+)?)\s*:\s*(\?)))$/i) {
  my $golden_ratio = (1 + sqrt(5)) / 2;
  my $result = 0; 
   
  if ($1 && $1 eq "?") {
    # ? : x
    $result = $2 / $golden_ratio;
    $answer_results = "$result : $2";
  } elsif ($4 && $4 eq "?") {
    # x : ? 
    $result = $3 * $golden_ratio; 
    $answer_results = "$3 : $result";
  } 
  
  $answer_type = "goldenratio";
  $is_memcached = 1;   
} 

