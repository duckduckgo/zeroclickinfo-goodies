package DDG::Goodie::MinecraftOres;
# ABSTRACT: Minecraft Ores reference

use DDG::Goodie;
use strict;
use JSON::MaybeXS;

zci answer_type => 'minecraft ores';
zci is_cached => 1;

triggers any => 'minecraft';

# Get goodie version for image paths
my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;
# Fetch and store recipes in a hash.
my $json = share('ores.json')->slurp;
#my $json = share('ores.json')->slurp(iomode => '<:encoding(UTF-8)'); # If description(s) contain(s) unicode
my $decoded = decode_json($json);
my %ores = map{ lc $_->{'name'} => $_ } (@{ $decoded->{'ores'} });
my @ore_names = sort { length($b) <=> length($a) } keys %ores;

handle remainder => sub {
    my $remainder = $_;
    my $ore;
    
    #find ore and regex
    foreach my $ore_name (@ore_names) {
        my $regex = $ores{$ore_name}->{'regex'} // $ore_name;
        if ($remainder =~ s/\b$regex\b//i) { 
            $ore = $ores{$ore_name}; 
            last; 
        }
    }
    return unless $ore;
    
    # Get image correct path
    my $image;
    my $imageName = $ore->{'imageName'};
    $image = "/share/goodie/minecraft_ores/$goodieVersion/images/$imageName";
    
    return "plaintxt",
        structured_answer => {

            data => {
                title    => $ore->{'name'},
                subtitle => $ore->{'sub'},
                image => $image,
                description => $ore->{'description'},
                infoboxData => [
                    {
                        label => "best layers:",
                        value => $ore->{'best'}
                    },
#                    {
#                        label => "common in layers:",
#                        value => $ore->{'common'}
#                    },
#                    {
#                        label => "rare in layers:",
#                        value => $ore->{'rare'}
#                    },
                    {
                        label => "found up to layer:",
                        value => $ore->{'foundupto'}
                    },
                    {
                        label => "minimum pickaxe tier:",
                        value => $ore->{'minTier'}
                    },
                    {
                        label => "found in",
                        value => $ore->{'found'}
                    },
                    {
                        label => "type:",
                        value => $ore->{'type'}
                    },
                    {
                        label => "blast resistance level:",
                        value => $ore->{'blastresistance'}
                    },
                    {
                        label => "hardness level:",
                        value => $ore->{'hardness'}
                    },
                    {
                        label => "experience obtained when mined:",
                        value => $ore->{'expmined'}
                    },
                    {
                        label => "experience obtained when smelted:",
                        value => $ore->{'expsmelted'}
                    },
                    {
                        label => "drop:",
                        value => $ore->{'drop'}
                    },
                    {
                        label => "first appearance:",
                        value => $ore->{'firstappearance'}
                    }                  
                ]     
            },
            meta => {
                sourceName => "Minecraft Wiki",
                sourceUrl => "http://minecraft.gamepedia.com/Ore"
            },

            templates => {
                group => 'info',
                options => {
                    moreAt => 1
                }
            }
        };
};

1;