#!/usr/bin/perl

use strict;
use warnings;
use Test;

BEGIN {plan};

# Insert to the tree

sub insert {
    my ($node, $word) = @_;
    
    # Insert an empty node if it does not exists
    $node = {} if !$node;
    
    # Insert each character recursively
    my $ch = substr($word, 0, 1);
    
    $node->{$ch} = insert($node->{$ch}, substr($word, 1)) if $ch;
    
    return $node;
}

# Convert the tree to DAWG

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

sub count_nodes {
    my ($node, $visited) = @_;
    
    return 0 if exists $visited->{$node};
    $visited->{$node} = 1;
    
    my $count = 0;
    for (keys %{$node}) {
        $count += 1 + count_nodes($node->{$_}, $visited);
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
    # to be able to assign offsets to the nodes. Use breadth-first search.
    my %visited;
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
            unshift @queue, $node->{$_};
        }
        $node->{'offset'} = $offset; # save offset in the node
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

print "Constructing the trees...\n";

while (<$f>) {
    next if m/^\s+$/;
    die "Invalid character <$1>" if m/([^a-z\n])/;
    
    # Encode the length
    my $len = length($_) - 1;
    $len = chr(ord('a') + $len);
    
    # Insert the normal word and the reverse word into the trees
    $forward_root = insert($forward_root, $len . $_);
    
    chomp;
    $reverse_root = insert($reverse_root, $len . reverse($_) . "\n");
}

print "Converting the trees to DAWGs... ";

$forward_root = remove_duplicates($forward_root, {});

print "(50% finished)\n";

$reverse_root = remove_duplicates($reverse_root, {});

print "Writing the files...\n";

write_binary($forward_root, 'dict_forward.bin');
write_binary($reverse_root, 'dict_reverse.bin');


#print_dawg($forward_root, 0, {}, 0);

#print count_nodes($forward_root, {}) . "\n";
