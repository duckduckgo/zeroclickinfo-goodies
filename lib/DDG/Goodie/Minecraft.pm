package DDG::Goodie::Minecraft;
# ABSTRACT: Minecraft crafting recipes.

use strict;
use DDG::Goodie;
use JSON::MaybeXS;

zci answer_type => 'minecraft';
zci is_cached => 1;

# Triggers: words that trigger the IA
triggers startend => "minecraft";

# Get goodie version for image paths
my $goodieVersion = $DDG::GoodieBundle::OpenSourceDuckDuckGo::VERSION // 999;
# Fetch and store recipes in a hash.
my $json = share('crafting-guide.json')->slurp;
#my $json = share('crafting-guide.json')->slurp(iomode => '<:encoding(UTF-8)'); # If description(s) contain(s) unicode
my $decoded = decode_json($json);
my %recipes = map{ lc $_->{'name'} => $_ } (@{ $decoded->{'items'} });
my @recipe_names = sort { length($b) <=> length($a) } keys %recipes;

# Extra words: Words that could be a part of the query, but not part of a recipe
my @extra_words = ('a','an','in','crafting','recipe','how to','make','craft','how do I','for','what is','the','on');

handle remainder => sub {
    my $remainder = $_;
    my $recipe;

    # Find recipe name and regex
    foreach my $recipe_name (@recipe_names) {
        my $regex = $recipes{$recipe_name}->{'regex'} // $recipe_name;

        if ($remainder =~ s/\b$regex\b//i) {
            $recipe = $recipes{$recipe_name};
            last;
       }
    }
    return unless $recipe; # Return if we don't have a valid recipe match

    # Remove the extra words (or phrases)
    foreach my $extra_word (@extra_words) {
        $remainder =~ s/\b$extra_word\b//gi;
    }
    return if $remainder && $remainder !~ m/^\s+$/; # Return if we had leftover unwanted words (not just whitespace)
    
    # Get image correct path
    my $image;
    my $imageName = $recipe->{'imageName'};
    my $localImage = $recipe->{'localImage'} // "no";
    
    if ($localImage eq "yes") { # If local image is used 
        $image = "/share/goodie/minecraft/$goodieVersion/images/$imageName";
    } else { # If remote image is used
        $image = $imageName;
    }

    # Run an answer
    my $plaintext = 'Minecraft ' . $recipe->{'name'} . ' ingredients: ' . $recipe->{'ingredients'} . '.';

    return $plaintext,
    structured_answer => {
        data => {
            title => $recipe->{'name'},
            subtitle => "Ingredients: " . $recipe->{'ingredients'},
            description => $recipe->{'description'},
            image => $image,
            imageTile => 1
        },
        meta => {
            sourceName => "Minecraft Wiki",
            sourceUrl => "http://minecraft.gamepedia.com/"  . uri_esc( $recipe->{'name'} ) # Not the best way to 
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