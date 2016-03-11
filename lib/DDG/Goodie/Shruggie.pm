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
use JSON::MaybeXS; # encoded the various other ASCII items in a JSON file


zci answer_type => "shruggie";
zci is_cached   => 1;

# Triggers
triggers start => "shruggie";

# Preload the JSON file
my $externalJSONFile = share('shruggiesfriends.json')->slurp;
my @arrayOfFriendFacesWithNames = @{decode_json($externalJSONFile)->{'Friends'}};

# Handle statement
handle remainder => sub {

    my $returnString;
    my $isJustShruggie = 0;
    my $stringAfterAnd;
    my %record_data = ("Shruggie", '¯\_(ツ)_/¯');
    my @record_keys = ("Shruggie");

    # Only search was "shruggie"
    if (!$_) {
        $isJustShruggie = 1;
    } elsif (m/^and (.+)/i) { # check if remainder matches pattern "and X"

        $stringAfterAnd = lc($1);

        if ($stringAfterAnd eq "friend") {

            my $pickRandomFriend = $arrayOfFriendFacesWithNames[rand @arrayOfFriendFacesWithNames];
            my $randomFriendsName = $pickRandomFriend->{'name'};


            $returnString = 'Shruggie and ' . $randomFriendsName;
            $record_data{$randomFriendsName} = $pickRandomFriend->{'image'};
            push @record_keys, $randomFriendsName;

        } elsif ($stringAfterAnd eq "friends") {

            $returnString = 'Shruggie and Friends';

            foreach my $iterateThroughFriends (@arrayOfFriendFacesWithNames) {
                my $currentForeachFriend = $iterateThroughFriends->{'name'};
                $record_data{$currentForeachFriend} = $iterateThroughFriends->{'image'};
                push @record_keys, $currentForeachFriend;
            }

        } else {

            foreach my $nameEmojiiPair (@arrayOfFriendFacesWithNames) {

                if (lc($nameEmojiiPair->{'name'}) eq $stringAfterAnd) {
                    my $friendsName = $nameEmojiiPair->{'name'};


                    $returnString = 'Shruggie and ' . $friendsName;
                    $record_data{$friendsName} = $nameEmojiiPair->{'image'};
                    push @record_keys, $friendsName;
                    last;
                }

            }

        }
    }

    #if the string after shruggie was ill formed
    if (!$returnString && !$isJustShruggie) {
        return;
    } elsif ($isJustShruggie) {
         return '¯\_(ツ)_/¯',
            structured_answer => {
            id => 'shruggie',
            name => 'Shruggie',
            description => 'Emojii for everone',
            templates => {
                group => 'text'
            },
            data => {
                title => '¯\_(ツ)_/¯',
                #subtitle => "Shruggie"  #I like it better without this, but either way is cool
            }
        }
    } else {

        return $returnString,
            structured_answer => {
            id => 'shruggie',
            name => 'Shruggie',
            description => 'Emojii for everone',
            meta => {
                sourceName => "Donger List",
                sourceUrl => "http://dongerlist.com/"
            },
            templates => {
                group => 'list',
                options => {
                    content => 'record'
                }
            },
            data => {
                title => $returnString,
                record_data => \%record_data,
                record_keys => \@record_keys
            }
        }
    }
};

1;
