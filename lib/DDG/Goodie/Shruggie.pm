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

zci answer_type => 'shruggie';
zci is_cached   => 1;

# Triggers
triggers any => 'shruggie','ascii emoji','ascii emoji art','emoji','emojicon','emoticon','emojiton','kaomoji','face mark';
triggers end => 'ascii';

# Preload the JSON file
my $externalJSONFile = share('shruggiesfriends.json')->slurp;
my @arrayOfFriendFacesWithNames = @{decode_json($externalJSONFile)->{'Friends'}};
# Handle statement
handle remainder => sub {

    my $returnString;
    my $stringAfterAnd;
    my %record_data;
    my @record_keys;
    if (!$_) {
        $returnString = '¯\_(ツ)_/¯';
        $record_data{'Shruggie'} = '¯\_(ツ)_/¯';
        push @record_keys, 'Shruggie';
    } elsif (m/and (.+)/i) { # check if remainder matches pattern "and X"

        $stringAfterAnd = lc($1);
        $record_data{'Shruggie'} = '¯\_(ツ)_/¯';
        push @record_keys, 'Shruggie';

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
    } elsif (m/(\w+)/i) { # case "Shruggie X"
        
        my $emojiiName = lc($_);
        if(my ($match) = grep{lc($_->{'name'}) eq $emojiiName} @arrayOfFriendFacesWithNames) {
            $returnString = 'Shruggie '.ucfirst($emojiiName);
            %record_data = ();
            $record_data{ucfirst($emojiiName)} = $match->{'image'};
            @record_keys = (ucfirst($emojiiName));
        }
        
    }

    #if the string after shruggie was ill formed
    if (!$returnString) {
        return;
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
