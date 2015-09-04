package DDG::Goodie::Shruggie;
# ABSTRACT: A simple goodie to show the shruggie (¯\_(ツ)_/¯) ASCII art
# when a user enter shruggie as their first search term.  
# 
# The goodie # will also show a second random face if the user searches "and friend"
# If the user does "and friends" all the available faces will show
# The user can also search "and [name]" to pick a certain friend to show
# with shruggie.  The available emojiis are loaded from an external JSON file


use DDG::Goodie;
use strict;
use utf8; # needed to properly use the various unicode characters in the emoticons
use JSON; # encoded the various other ASCII items in a JSON file
use Try::Tiny;

zci answer_type => "shruggie";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "Shruggie";
description "Shows the ASCII art shruggie (¯\_(ツ)_/¯) as an easter egg when the user searches shruggie";
primary_example_queries "shruggie";
secondary_example_queries "shruggie and friend", "shruggie and friends", "shruggie and [name of a particular ASCII face]";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
category "random";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
topics "geek";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Shruggie.pm";
attribution github => ["Epik", "Epik"],
            twitter => "nyuepik";

# Triggers
triggers start => "shruggie";



# Handle statement
handle remainder => sub {

    my $returnString = '¯\_(ツ)_/¯';

    # Only search was "shruggie"
    if (!$_) {
        return $returnString,
        structured_answer => {
            input     => [],
            result    => [$returnString]
        };        
    }
    
    my $checkIfAndIsSecondSearchTerm = lc($_);
    if (index($checkIfAndIsSecondSearchTerm, "and ") == 0) {
        
        # Delay loading JSON file of emojiis until we know we need it 
        my $externalJSONFile = share('shruggiesfriends.json')->slurp;
        
        my @arrayOfFriendFacesWithNames = @{decode_json($externalJSONFile)->{'Friends'}};
        
        my $stringAfterAnd = substr($checkIfAndIsSecondSearchTerm,4);
    
        if ($stringAfterAnd eq "friend") {
        
            my $pickRandomFriend = $arrayOfFriendFacesWithNames[rand @arrayOfFriendFacesWithNames];
        
            #$returnString .= " _____<br>_ " . $pickRandomFriend->{'image'},      
            return $returnString,
            structured_answer => {
                input     => [],
                result    => $returnString . " _____ " . $pickRandomFriend->{'image'}
            };
         
         } elsif ($stringAfterAnd eq "friends") {
            my @returnArray = ($returnString);
         
            foreach my $iterateThroughFriends (@arrayOfFriendFacesWithNames) {
                $returnString .= " _____ " . $iterateThroughFriends->{'image'};
            }
            
            return $returnString,
            structured_answer => {
                input     => [],
                result    => $returnString
            };
            
        } else {
            
            foreach my $nameEmojiiPair (@arrayOfFriendFacesWithNames) {

                if (lc($nameEmojiiPair->{'name'}) eq $stringAfterAnd) {
                    return $returnString . " ______ " . $nameEmojiiPair->{'image'};
                }
            
            }
            
        }
    }
    
     # Don't trigger shruggie
    return;
};

1;
