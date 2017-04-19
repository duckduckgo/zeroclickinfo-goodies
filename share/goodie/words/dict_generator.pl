#!/usr/bin/perl

# The dictionary is stored in a DAWG (direct acyclic word graph).
# The data structure is described in the following articles:
#   * Appel, Jacobson. The world's fastest Scrabble program. Communications of the ACM. Volume 31 Issue 5, May 1988.
#   * http://www.strchr.com/ternary_dags
#   * http://www.strchr.com/dawg_predictive
#   * http://stevehanov.ca/blog/index.php?id=115

# Each node is stored in a binary file as a sorted array of outgoing edges.
# Each edge is stored as three bytes: 5 bits for the character code, 1 bit for the 'last edge' bit,
# and 18 bits for the offset of the node. The offset is the number of the first edge
# outgoing from the node. The edges outgoing from a node are sorted by the character code;
# the last edge has a special bit set. The character code is zero for the end of the word
# (stored as "\n" in the internal structures of the generator), one for 'a', two for 'b', etc.

# There are two dictionaries: one for searching from the start of the word and another one
# for searching backwards. Depending on a pattern, the program chooses one of them.

# At the root of each dictionary, there are edges for different word lengths. The length is encoded
# as 'b' for 1-letter words, 'c' for 2-letter words, etc. Together, the reverse dictionary and
# the edges for different word lengths increase the size of the dictionary file by 3-4 times.
# However, we can answer some queries (such as '6-character word which ends in ex') faster with them.

# The generator script first builds two tries (for the usual and the reverse dictionary), then
# compresses them into DAWGs, and saves them in two binary files.

use strict;
use warnings;
use Test;

BEGIN {plan};

# Insert to the trie

sub insert {
    my ($node, $word) = @_;
    
    # Insert an empty node if it does not exists
    $node = {} if !$node;
    
    # Insert each character recursively
    my $ch = substr($word, 0, 1);
    
    $node->{$ch} = insert($node->{$ch}, substr($word, 1)) if $ch;
    
    return $node;
}

# Convert the trie to DAWG

# Recursively calculate a hash for the subtree
sub get_hash {
    my $node = shift;
    
    my $hash = 0;
    
    for (sort keys %{$node}) {
        $hash = $hash * 31 + (ord($_) ^ get_hash($node->{$_}));
    }
    
    return $hash;
}

# Check if the two subtrees are equal
sub is_equal {
    my ($a, $b) = @_;
    
    for (keys %{$b}) {
        return 0 if !exists $a->{$_};
    }
    
    for (keys %{$a}) {
        return 0 if !exists $b->{$_} ||
                    !is_equal($a->{$_}, $b->{$_});
    }
    
    return 1;
}

ok( is_equal({}, {}), 1 );
ok( is_equal({'a' => {}}, {'a' => {}}), 1 );
ok( is_equal({'a' => {}}, {}), 0 );
ok( is_equal({}, {'b' => {}}), 0 );
ok( is_equal({'a' => {}}, {'b' => {}}), 0 );
ok( is_equal({'a' => {'c' => {}}}, {'a' => {}}), 0 );
ok( is_equal({'a' => {'b' => {}}}, {'a' => {'b' => {}}}), 1 );
ok( is_equal({'a' => {}, 'b' => {}}, {'a' => {}, 'b' => {}}), 1 );

ok( get_hash({}), 0 );
ok( get_hash({'a' => {}}), ord('a') );
ok( get_hash({'a' => {'b' => {}}}), ord('a') ^ ord('b') );
ok( get_hash({'a' => {}, 'b' => {}}), ord('a') * 31 + ord('b') );

sub remove_duplicates {
    my ($node, $seen) = @_;
    
    # Find the node in the already seen nodes
    my $hash = get_hash($node);
    
    for (@{$seen->{$hash}}) {
        return $_ if (is_equal($node, $_));
    }
    
    # Add the node to the seen nodes
    push @{$seen->{$hash}}, $node;
    
    # Recursively examine the subtrees
    for (keys %{$node}) {
        $node->{$_} = remove_duplicates($node->{$_}, $seen);
    }
    
    return $node;
}

# For debugging purposes only

sub count_edges {
    my ($node, $visited) = @_;
    
    return 0 if exists $visited->{$node};
    $visited->{$node} = 1;
    
    my $count = 0;
    for (keys %{$node}) {
        $count += 1 + count_edges($node->{$_}, $visited);
    }
    
    return $count;
}

sub print_dawg {
    my ($node, $level, $visited, $line) = @_;
    
    if (exists $visited->{$node}) {
        print ' ' x $level . '= ' . $visited->{$node} . "\n";
        return $line;
    }
    $visited->{$node} = $line;
    
    for (sort keys %{$node}) {
        next if $_ eq 'offset';
        print( sprintf("%-30s[%d]\n", (' ' x $level) . ($_ eq "\n" ? 'end' : $_), $line) );
        $line++;
        $line = print_dawg($node->{$_}, $level + 1, $visited, $line);
    }
    
    return $line;
}


# Output the binary file

sub write_binary {
    my ($root, $filename) = @_;
    
    # The DAWG contains forward references, so we need to linearize it first
    # to be able to assign offsets to the edges. Use breadth-first search.
    my %visited; # Visited nodes
    my @queue = ($root);
    my @output;
    
    while (@queue) {
        my $node = pop(@queue);
        
        next if (exists $visited{$node});
        $visited{$node} = 1;
        
        my $offset = scalar(@output);
        my $i = 0;
        for (sort keys %{$node}) {
            $i++;
            push @output, [$_, $node->{$_}, $i == scalar(keys %{$node})];
            unshift @queue, $node->{$_}; # Add to the queue
        }
        $node->{'offset'} = $offset; # Save offset in the node
    }
    
    # Write to the file
    
    open(my $fo, '>', $filename) or die;
    binmode $fo;
    
    for (@output) {
        my ($ch, $node, $end) = @{$_};
        
        my $code = $ch eq "\n" ? 0 : ord($ch) - ord('a') + 1;
        die "Invalid character <$ch>" if $code < 0 || $code >= 32;
        
        die "Offset too large" if $node->{'offset'} >= 2**18;
        
        $code |= ($end << 5) | ($node->{'offset'} << 6);
                
        print $fo pack('CCC', $code & 0xFF, ($code >> 8) & 0xFF, ($code >> 16) & 0xFF);
    }
}


open(my $f, '<', 'enable2k.txt') or die;

my ($forward_root, $reverse_root); # Reference to the DAWG root

print "Constructing the tries...\n";

while (<$f>) {
    next if m/^\s+$/;
    die "Invalid character <$1>" if m/([^a-z\n])/;
    
    # Encode the length
    my $len = length($_) - 1;
    $len = chr(ord('a') + $len);
    
    # Insert the normal word and the reversed word into the trees
    $forward_root = insert($forward_root, $len . $_);
    
    chomp;
    $reverse_root = insert($reverse_root, $len . reverse($_) . "\n");
}

print "Converting the tries to DAWGs... ";

$forward_root = remove_duplicates($forward_root, {});

print "(50% finished)\n";

$reverse_root = remove_duplicates($reverse_root, {});

print "Writing the files...\n";

write_binary($forward_root, 'dict_forward.bin');
write_binary($reverse_root, 'dict_reverse.bin');


#print_dawg($forward_root, 0, {}, 0);

#print count_edges($forward_root, {}) . "\n";
