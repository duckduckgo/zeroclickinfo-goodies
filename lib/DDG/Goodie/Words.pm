package DDG::Goodie::Words;
# ABSTRACT: Show some words matching the specified criteria.

use DDG::Goodie;

use strict;
use warnings;

zci answer_type => 'word_list';
zci is_cached   => 1;

primary_example_queries 'words starting with duck', '9-letter words like cro*rd', '20 words', 'random words with 4 letters';
secondary_example_queries '5 6-letter words ending in ay', 'words like cro----rd';
description 'find words for puzzles and word games';
name 'Words';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Words.pm';
category 'language';
topics 'words_and_games';

attribution github => ['https://github.com/pavlos256', 'Pavlos Touboulidis'];

triggers any => 'words', 'word';

use constant {
    # Number of words to return if not specified
    DEFAULT_WORD_COUNT => 10,

    # Maximum number of words to return
    MAX_WORD_COUNT => 50,

    # Perf: Maximum number of visited edges allowed
    # to answer a query. Most queries don't need
    # that many but some open-ended word specs
    # (like '*abcde*') require too many matches.
    BACKTRACKING_LIMIT => 1000,
};

handle query_lc => sub {
    my $query = shift;

    my ($word_count, $word_length, $pattern) = parse_input($query);
    return unless $word_count;

    my @words = get_matching_words($word_count, $word_length, $pattern);
    return unless @words;

    my $plain_result = join ", ", @words;

    return $plain_result,
        structured_answer => {
            input     => [describe_input($word_count, $word_length, $pattern)],
            operation => 'Words',
            result    => $plain_result
        };
};

sub describe_input {
    my ($word_count, $word_length, $pattern) = @_;

    my @a;

    # word count
    my $t = $word_count == 1 ? 'word' : 'words';
    push @a, ($word_count == 1 ? 'one' : $word_count) unless $word_count == 0;

    # letter count
    push @a, "$word_length-letter" if $word_length;

    # 'word'
    push @a, $t;

    # verb & pattern
    if ($pattern =~ s/^([a-z]+)\*$/$1/) {
        push @a, "starting with $pattern";
    } elsif ($pattern =~ s/^\*([a-z]+)$/$1/) {
        push @a, "ending in $pattern";
    } elsif ($pattern ne '*') {
        push @a, "like $pattern";
    }

    return join ' ', @a;
}

sub parse_input
{
    # The input is expected to be in lowercase (which it is because of 'handle query_lc')
    my $s = shift;

    my ($word_count, $word_length, $verb, $pattern);

    return unless $s =~ m/
        (?:(?<count>\d+)\s+)?
        (?:(?<length>\d+)[\s\-]+(?:letter|char|character)\s+)?
        (?:random\s+)?(?<word>word[s]?)
        (?:\s+(?:having|with)\s+(?<length>\d+)\s+(?:letters|characters))?
        (?:
            \s+
            (?:(?:which|that)\s+)?
            (?:(?:(?<verb>start|begin)(?:s|ing|ning)?+(?:\s+(?:in|with)?)?+)|(?:(?<verb>end)(?:s|ing)?+(?:\s+(?:in|with)?)?+)|(?:(?<verb>like)))
            (?:\s+)
            (?<pattern>[a-z\-\?\.\*]{1,28})
        )?
        (?:\s+(?:having|with)\s+(?<length>\d+)\s+(?:letters|characters))?
    /x;
 
    # Word count
    $word_count = ($+{'word'} eq 'words') ? DEFAULT_WORD_COUNT : 1;
    $word_count = $+{'count'} if $+{'count'};
    $word_count = MAX_WORD_COUNT if $word_count > MAX_WORD_COUNT;

    # Word length
    $word_length = $+{'length'} || 0;

    # Verb
    $verb = $+{'verb'} || '';
    $verb = 'start' if $verb eq 'begin';

    # Pattern
    $pattern = $+{'pattern'} || '*';

    # Don't process too wrong or unrelated queries
    return if !$+{'count'} && !$word_length && (!$verb || $pattern eq '*');

    if (($verb eq 'start') || ($verb eq 'end')) {
        # Remove any symbols from the pattern
        $pattern =~ s/[^a-z]//g;

        # Normalize pattern
        $pattern = ($verb eq 'start') ? "$pattern*" : "*$pattern";
    } elsif ($verb eq 'like') {
        # Replace all single-character symbols (- ?) with '.'
        $pattern =~ tr/-?/../;

        # Remove duplicate '*'
        $pattern =~ s/\*+/*/g;

        # Since the verb is 'like',
        # we abort if there's no wildcards in the pattern
        return unless $pattern =~ tr/\*\.//;

        # If the string is just dots, clear the pattern
        # and set the word_length to the number of dots.
        if ($pattern eq '.' x length($pattern)) {
            $word_length = length($pattern);
            $pattern = '*';
        }
    }

    return ($word_count, $word_length, $pattern);
}

# Load the binary file
sub load_dict {
    my $filename = shift;
    
    open my $f, '<', share() . '/' . $filename or die;
    
    my $content;
    read $f, $content, -s $f;
    
    close $f;
    
    return $content;
}

my $forward_dict = load_dict('dict_forward.bin');
my $reverse_dict = load_dict('dict_reverse.bin');

# Read the edge at the specified position
sub read_at_pos {
    my ($dict, $pos) = @_;
    
    # Read three bytes
    my $a = vec ${$dict}, $pos * 3, 8;
    my $b = vec ${$dict}, $pos * 3 + 1, 8;
    my $c = vec ${$dict}, $pos * 3 + 2, 8;
    
    my $code = $a | ($b << 8) | ($c << 16);
    
    # Extract character code, offset of the node, and the last edge bit
    my $ch = $code & 0x1F;
    $ch = ($ch == 0) ? '' : chr(ord('a') + $ch - 1);
    my $offset = $code >> 6;
    my $end = ($code >> 5) & 1;
    
    return ($ch, $offset, $end);
}

# The matching function
sub search_in_dict {
    my ($res, $pattern, $pos, $search) = @_;
    
    my ($dict_ch, $new_pos, $end, @matches);
    
    # Match the first character. If it's a star, then match the next character
    my $ch = substr($pattern, 0, 1);
    my $is_star = $ch eq '*';
    $ch = substr($pattern, 1, 1) if $is_star;
    
    # Check all edges until this character. Put z here if all edges must be checked
    my $last_ch = ($ch eq '.' || $is_star) ? 'z' : $ch;
    
    # Read all edges outgoing from the node
    do {
        ($dict_ch, $new_pos, $end) = read_at_pos($search->{dict}, $pos);
        
        # Limit the overall number of visited edges
        $search->{counter}++;
        return @matches if $search->{counter} > BACKTRACKING_LIMIT;
        
        # If found the letter
        if ($dict_ch eq $ch || $ch eq '.') {
            return $res if $dict_ch eq '' && $ch eq ''; # End of the word
            
            # Search for the next letter
            push @matches, search_in_dict($res . $dict_ch, substr($pattern, $is_star ? 2 : 1),
                $new_pos, $search);
            return @matches if scalar(@matches) >= $search->{word_count}; # Stop if found enough words
        }
        
        # If it's a star, try to skip the letter
        push @matches, search_in_dict($res . $dict_ch, $pattern,
            $new_pos, $search) if $is_star && $dict_ch ne '';
        return @matches if scalar(@matches) >= $search->{word_count};
        
        $pos++; # Advance to the next edge
    } until ($end || $dict_ch ge $last_ch);
    
    return @matches;
}

sub get_matching_words {
    my ($word_count, $word_length, $pattern) = @_;

    # Find the dictionary to use
    return unless $pattern =~ m/^([a-z]*).*?([a-z]*)$/;
    my $use_reverse = length($1) < length($2);
    my $dict = $use_reverse ? \$reverse_dict : \$forward_dict;
    $pattern = reverse $pattern if $use_reverse;

    # Add encoded word length if specified
    my $len = $word_length ? chr(ord('a') + $word_length) : '.';

    # Do the search
    my @matches = map {substr($_, 1)} search_in_dict('', $len . $pattern, 0,
        {'dict' => $dict, 'counter' => 0, 'word_count' => $word_count});

    # Reverse the found words when using the reverse dictionary
    @matches = map {scalar reverse($_)} @matches if $use_reverse;

    # Crop the array if found more words than needed
    @matches = @matches[0..$word_count - 1] if @matches > $word_count;
    
    return @matches;
}

1;
