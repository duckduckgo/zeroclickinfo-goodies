package DDG::Goodie::Words;
# ABSTRACT: Show some words matching the specified criteria.

use DDG::Goodie;
use List::Util "shuffle";

zci answer_type => 'word_list';
# Don't cache answers because we return random words
zci is_cached   => 0;

primary_example_queries 'words starting with duck', '9-letter words like cro*rd', '20 words', 'random words with 4 letters';
secondary_example_queries '5 6-letter words ending in ay', 'words like cro----rd';
description 'find words for puzzles and word games';
name 'Words';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Words.pm';
category 'language';
topics 'words_and_games';

attribution github => ['https://github.com/pavlos256', 'Pavlos Touboulidis'];

triggers any => 'words', 'word';
triggers startend => 'words', 'word';

use constant {
    # Number of words to return if not specified
    DEFAULT_WORD_COUNT => 10,

    # Maximum number of words to return
    MAX_WORD_COUNT => 50,

    # Perf: Maximum number of regex matches allowed
    # to answer a query. Most queries don't need
    # that many but some open-ended word specs
    # (like '*abcde*') require too many matches.
    MAX_MATCH_TESTS => 2500,

    # Perf: Maximum number of successful matches.
    # If we have this much, we pick the results
    # out of these matches.
    MAX_INITIAL_RESULTS => 1000
};

handle query_lc => sub {
    my $query = shift;

    my ($word_count, $min_word_length, $max_word_length, $pattern) = parse_input($query);
    return unless $word_count;

    my @words = get_matching_words($word_count, $min_word_length, $max_word_length, $pattern);
    return unless @words;

    my $plain_result = join ", ", @words;

    return $plain_result,
        structured_answer => {
            input     => [describe_input($word_count, $min_word_length, $max_word_length, $pattern)],
            operation => 'Words',
            result    => $plain_result
        };
};

# Load word list and create index
my $MIN_WORD_LENGTH = 0;
my $MAX_WORD_LENGTH = 0;

my @regular_sorted_words = sort map { chomp $_; $_ } share('enable2k.txt')->slurp;
my @reverse_sorted_words = sort map { scalar reverse $_ } @regular_sorted_words;
# Sort by length, but shuffle the words of equal length. This helps return words that
# are more random for a query having word-length criteria.
# For example, there are too many words with 10 letters; over MAX_INITIAL_RESULTS.
# Without shuffling, the initial results will most probably be full of words starting
# with 'a'. With shuffling, those initial results will be more random. It's not perfect;
# not all 10-letter words will be considered.
my @length_sorted_words = sort { (length($a) <=> length($b)) || (rand() < 0.5 ? -1: 1) } @regular_sorted_words;
my %regular_word_index = create_index_by_starting_letters(\@regular_sorted_words);
my %reverse_word_index = create_index_by_starting_letters(\@reverse_sorted_words);
my %length_word_index = create_index_by_length(\@length_sorted_words);
@reverse_sorted_words = map { scalar reverse $_ } @reverse_sorted_words;

sub describe_input {

    my ($word_count, $min_word_length, $max_word_length, $pattern) = @_;

    my @a = ();

    # word count
    my $t = $word_count == 1 ? 'word' : 'words';
    push @a, ($word_count == 1 ? 'one' : $word_count) unless $word_count == 0;

    # letter count
    push @a, "$min_word_length-letter" if ($min_word_length && $min_word_length == $max_word_length);

    # 'word'
    push @a, $t;

    # verb & pattern
    if ($pattern) {
        if ($pattern =~ s/^([a-z]+)\*$/$1/) {
            push @a, "starting with $pattern";
        } elsif ($pattern =~ s/^\*([a-z]+)$/$1/) {
            push @a, "ending in $pattern";
        } else {
            push @a, "like $pattern";
        }
    }

    return join ' ', @a;
}

sub create_index_by_starting_letters {
# Create an index like:
# a => [0, 2000],
# aa => [0, 15],
# ab => [15, 500],
# ...
# zy => [j, n],
# zz => [n, total_words]

    my $words_ref = $_[0];
    my $total_words = @{$words_ref};

    my %dict = ();
    my $pp1 = '';
    my $pp2 = '';

    for my $m (ord('a') .. ord('z')) {
        $dict{chr($m)} = [0, $total_words];
        for my $n (ord('a') .. ord('z')) {
            $dict{chr($m) . chr($n)} = [0, 0];
        }
    }

    for my $i (0 .. $#{$words_ref}) {
        my $w = ${$words_ref}[$i];

        my $p1 = substr($w, 0, 1);
        if ($p1 ne $pp1) {
            if ($pp1) {
                $dict{$pp1}[1] = $i;
            }
            $pp1 = $p1;
            $dict{$p1} = [$i, 0];
        }

        if (length($w) > 1) {
            my $p2 = substr($w, 0, 2);
            if ($p2 ne $pp2) {
                if ($pp2) {
                    $dict{$pp2}[1] = $i;
                }
                $pp2 = $p2;
                $dict{$p2} = [$i, 0];
            }
        }
    }
    if ($pp1) {
        $dict{$pp1}[1] = $total_words;
    }
    if ($pp2) {
        $dict{$pp2}[1] = $total_words;
    }

    return %dict;
}

sub create_index_by_length {
# Create an index like:
# 2 => [0, 200],
# 3 => [200, 3000],
# ...
# 28 => [n, total_words]

    my $words_ref = $_[0];
    my $total_words = @{$words_ref};

    my %dict = (0 => [0, 0]);
    my $plen = 0;

    $MIN_WORD_LENGTH = length($words_ref->[0]);
    $MAX_WORD_LENGTH = $MIN_WORD_LENGTH;

    for my $i (0 .. $#{$words_ref}) {
        my $len = length($words_ref->[$i]);

        if ($len != $plen) {
            $dict{$plen}[1] = $i;

            $plen = $len;
            $dict{$len} = [$i, 0];

            if ($len < $MIN_WORD_LENGTH) {
                $MIN_WORD_LENGTH = $len;
            }
            if ($len > $MAX_WORD_LENGTH) {
                $MAX_WORD_LENGTH = $len;
            }
        }
    }
    $dict{$plen}[1] = $total_words;

    return %dict;
}

sub parse_input
{
    # The input is expected to be in lowercase (which it is because of 'handle query_lc')
    my $s = shift;

    my ($word_count, $min_word_length, $max_word_length, $verb, $pattern);

    if ($s =~ m/
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
    /x)
    {
        # Word count
        my $raw_word_count = $+{'count'} || 0;
        $word_count = ($+{'word'} eq 'words') ? DEFAULT_WORD_COUNT : 1;
        $word_count = $raw_word_count if $raw_word_count;
        $word_count = MAX_WORD_COUNT if $word_count > MAX_WORD_COUNT;

        # Word length
        my $word_length = $+{'length'} || 0;
        $min_word_length = $max_word_length = $word_length;

        # Verb
        $verb = $+{'verb'} || '';
        $verb = 'start' if $verb eq 'begin';

        # Pattern
        my $raw_pattern = $+{'pattern'} || '';
        $pattern = $raw_pattern;
        if (($verb eq 'start') || ($verb eq 'end')) {
            # Remove any symbols from the pattern
            $pattern =~ s/[^a-z]//g;

            # Normalize pattern
            if ($pattern) {
                if (!$word_length) {
                    $min_word_length = length($pattern) + 1;
                    $max_word_length = $MAX_WORD_LENGTH;
                }
                if ($verb eq 'start') {
                    $pattern = $pattern . '*';
                } else {
                    $pattern = '*' . $pattern;
                }
            }
        } elsif ($verb eq 'like') {
            # Replace all single-character symbols (- ?) with '.'
            $pattern =~ tr/-?/../;

            # Remove duplicate '*'
            $pattern =~ s/\*+/*/g;

            # Since the verb is 'like',
            # we abort if there's no wildcards in the pattern
            return unless $pattern =~ tr/\*\.//;

            # If the string is just '*', clear the pattern
            if ($pattern eq '*') {
                $pattern = '';
            } else {
                # If the string is just dots, clear the pattern
                # and set the word_length to the number of dots.
                if ($pattern eq '.' x length($pattern)) {
                    $min_word_length = $max_word_length = length($pattern);
                    $pattern = '';
                } elsif (!$word_length) {
                    # Set the min word length to the length of the pattern
                    $min_word_length = length($pattern);
                    $max_word_length = $MAX_WORD_LENGTH;
                }
            }
        }

        # If there's no pattern, make sure we clear the verb too.
        $verb = '' unless $pattern;

        # Don't process too wrong or unrelated queries
        if (($raw_word_count == 0 && $min_word_length == 0 && $max_word_length == 0) && (!$verb || !$pattern)) {
            return 0;
        }

        return ($word_count, $min_word_length, $max_word_length, $pattern);
    }

    return 0;
}

sub get_matching_words
{
    my ($word_count, $min_word_length, $max_word_length, $pattern) = @_;

    # The wordlist to use
    my $words_ref = \@regular_sorted_words;

    # The index in the wordlist to begin looking for matches
    my $start_index = 0;

    # The index in the wordlist after the last possible match
    my $end_index = @{$words_ref};

    # Flag indicating that the pattern does not need to
    # be matched any more (because it was implicitly matched
    # by the use of an index)
    my $remove_pattern = 0;

    if ($pattern) {
        # If the beginning or the end of the pattern
        # is not wildcards, use it to limit the search range.

        my ($a_key, $a_start, $a_end, $b_key, $b_start, $b_end);
        if ($pattern =~ m/^([a-z]{1,2})/) {
            $a_key = $1;
            $a_start = $regular_word_index{$a_key}[0];
            $a_end = $regular_word_index{$a_key}[1];
        }
        if ($pattern =~ m/([a-z]{1,2})$/) {
            $b_key = reverse $1;
            $b_start = $reverse_word_index{$b_key}[0];
            $b_end = $reverse_word_index{$b_key}[1];
        }

        if ($a_key && $b_key) {
            if (($a_end - $a_start) <= ($b_end - $b_start)) {
                # 'a' has less elements, use it.
                $words_ref = \@regular_sorted_words;
                $start_index = $a_start;
                $end_index = $a_end;
                # We have already matched the whole pattern, so remove it
                # Example: pattern is 'aa*', we've already limited to
                # the 'aa' subrange. If the pattern was 'aab*' then
                # we'd still need it.
                $remove_pattern = ($a_key . '*' eq $pattern) ? 1 : 0;
            } else {
                # 'b' has less elements, use it.
                $words_ref = \@reverse_sorted_words;
                $start_index = $b_start;
                $end_index = $b_end;
                # We have already matched the whole pattern, so remove it
                $remove_pattern = ('*' . $b_key eq $pattern) ? 1 : 0;
            }
        } elsif ($a_key) {
            $words_ref = \@regular_sorted_words;
            $start_index = $a_start;
            $end_index = $a_end;
            # We have already matched the whole pattern, so remove it
            $remove_pattern = ($a_key . '*' eq $pattern) ? 1 : 0;
        } elsif ($b_key) {
            $words_ref = \@reverse_sorted_words;
            $start_index = $b_start;
            $end_index = $b_end;
            # We have already matched the whole pattern, so remove it
            $remove_pattern = ('*' . $b_key eq $pattern) ? 1 : 0;
        }
        # otherwise, we need to search all the words.
    }

    # Total number of possible matches
    my $available_count = $end_index - $start_index;

    # If there are word length limits, check the index and see
    # if it will limit the search space.
    if ($min_word_length && $max_word_length) {
        my $min = 0;
        my $max = 0;

        for (my $len = $min_word_length; $len <= $max_word_length; $len++) {
            my $v = $length_word_index{$len};
            next unless $v;
            $min = $v->[0] unless $min;
            $max = $v->[1];
        }

        my $count = $max - $min;

        # Pick the length index if it will reduce the possible matches.
        # However, picking this will enforce pattern checking (if a pattern exists),
        # which is slower than length checking.
        my ($PATTERN_COST, $LENGTH_CHECK_COST, $OVER_MAX_TESTS_COST, $LENGTH_MATCHES_PERCENT) = (2, 1, 4, 0.1);
        my $this_cost = $count * ($pattern ? $PATTERN_COST : $LENGTH_CHECK_COST) * ($count > MAX_MATCH_TESTS ? $OVER_MAX_TESTS_COST : 1);
        my $other_cost = $available_count * $LENGTH_CHECK_COST
                        + $available_count * $LENGTH_MATCHES_PERCENT * ($pattern ? ($remove_pattern ? 0 : $PATTERN_COST) : 0);

        if ($this_cost < $other_cost) {
            # Use this index instead
            $available_count = $count;
            $words_ref = \@length_sorted_words;
            $start_index = $min;
            $end_index = $max;

            # We will check the pattern
            $remove_pattern = 0;
            # But not the length, ever again
            $min_word_length = $max_word_length = 0;
        }
    }

    $pattern = '' if $remove_pattern;

    my @matches = ();

    if ($pattern) {
        # With pattern check.

        # Perf: Stop searching for more matches when we have this much
        my $cut_off = MAX_INITIAL_RESULTS;
        $cut_off = $available_count if $available_count < $cut_off;

        my $re_pattern = $pattern =~ s/\*/.+/rg;
        my $rex = qr/^$re_pattern$/;

        for (my $i = $start_index, my $k = 0; $i < $end_index; $i++) {
            my $w = $words_ref->[$i];
            my $w_len = length($w);
            next if (($min_word_length && $w_len < $min_word_length) || ($max_word_length && $w_len > $max_word_length));
            last if (++$k > MAX_MATCH_TESTS);
            next unless ($w =~ $rex);
            last if (push(@matches, $w) >= $cut_off);
        }
    } else {
        # No pattern check.

        if ($min_word_length || $max_word_length) {
            for (my $i = $start_index; $i < $end_index; $i++) {
                my $w_len = length($words_ref->[$i]);
                next if (($min_word_length && $w_len < $min_word_length) || ($max_word_length && $w_len > $max_word_length));
                last if (push(@matches, $words_ref->[$i]) >= MAX_INITIAL_RESULTS);
            }
        } else {
            for (my $i = $start_index; $i < $end_index; $i++) {
                last if (push(@matches, $words_ref->[$i]) >= MAX_INITIAL_RESULTS);
            }
        }
    }

    if (@matches > $word_count) {
        @matches = shuffle(@matches);
        @matches = splice(@matches, 0, $word_count);
    }

    return sort @matches;
}

1;
