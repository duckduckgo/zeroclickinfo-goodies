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

    # Find ore and regex
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
    
    my $plaintext = 'Minecraft ' . $ore->{'name'} . '.';

    return "$plaintext",
        structured_answer => {

            data => {
                title    => $ore->{'name'},
                url => "https://minecraft.gamepedia.com/"  . uri_esc( $ore->{'name'} ), # Not the best way
                subtitle => $ore->{'sub'},
                image => $image,
                description => $ore->{'description'},
                infoboxData => [
                    {
                        heading => "Ore specifications"
                    },
                    {
                        label => "Best Layers:",
                        value => $ore->{'best'},
                        url => "https://minecraft.gamepedia.com/Ore#Availability"
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
                        label => "Found up to Layer:",
                        value => $ore->{'foundupto'},
                        url => "https://minecraft.gamepedia.com/Ore#Availability"
                    },
                    {
                        label => "Minimum Pickaxe Tier:",
                        value => $ore->{'minTier'},
                        url => "https://minecraft.gamepedia.com/Pickaxe#Mining"
                    },
                    {
                        label => "Found in",
                        value => $ore->{'found'},
                        url => "https://minecraft.gamepedia.com/Dimensions"
                    },
                    {
                        heading => "General"
                    },
                    {
                        label => "Type:",
                        value => $ore->{'type'}
                    },
                    {
                        label => "Blast Resistance Level:",
                        value => $ore->{'blastresistance'},
                        url => "https://minecraft.gamepedia.com/Explosion#Blast_resistance"
                    },
                    {
                        label => "Hardness Level:",
                        value => $ore->{'hardness'},
                        url => "https://minecraft.gamepedia.com/Breaking#Blocks_by_hardness"
                    },
                    {
                        label => "Experience obtained when Mined:",
                        value => $ore->{'expmined'},
                        url => "https://minecraft.gamepedia.com/Experience#Experience_amounts_by_source"
                    },
                    {
                        label => "Experience obtained when Smelted:",
                        value => $ore->{'expsmelted'},
                        url => "https://minecraft.gamepedia.com/Experience#Experience_amounts_by_source"
                    },
                    {
                        label => "Drop:",
                        value => $ore->{'drop'},
                        url => "https://minecraft.gamepedia.com/Drops"
                    },
                    {
                        label => "First Appearance:",
                        value => $ore->{'firstappearance'},
                        url => "https://minecraft.gamepedia.com/Version_history"
                    }
                ]
            },
            meta => {
                sourceName => "Minecraft Wiki",
                sourceUrl => "https://minecraft.gamepedia.com/Ore#Availability"
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