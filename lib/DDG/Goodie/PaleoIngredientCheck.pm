package DDG::Goodie::PaleoIngredientCheck;
# ABSTRACT: Indicates if a given food item is known to be safe or unsafe on the paleo diet.

use DDG::Goodie;

triggers startend => share('triggers.txt')->slurp;

zci answer_type => "paleo_ingredient_check";
zci is_cached   => 1;

my @safe_array = share('safe.txt')->slurp;
my %safe_keywords = map { chomp; $_ => 1 } @safe_array;
my @unsafe_array = share('unsafe.txt')->slurp;
my %unsafe_keywords = map { chomp; $_ => 1 } @unsafe_array;

# p(%safe_keywords);
# warn($safe_keywords{"apple"});

handle remainder => sub {
    return unless $_;
    my $item = lc($_);

    # Remove any preceding "is" or "are" text from the query.
    $item =~ s/^(is|are)[\W]+//;

    my $is_plural = substr($item, -1) eq "s";
    my $itemAlt = $is_plural ? substr($item, 0, -1) : $item."s"; # pluralized or unpluralized form
    my $result;

    # warn "ITEM IS: $item";
    # warn "ITEM ALT IS: $itemAlt";

    if (exists $safe_keywords{$item} || exists $safe_keywords{$itemAlt}) {
        $result = "Yes";
    } elsif (exists $unsafe_keywords{$item} || exists $unsafe_keywords{$itemAlt}) {
        $result = "No";
    }

    return unless $result; # ensure we have a result

    return $result, structured_answer => {
        data => {
            title => $result,
            subtitle => "Paleo Friendly: $item"
        },
        templates => {
            group => 'text'
        }
    };
};

1;
