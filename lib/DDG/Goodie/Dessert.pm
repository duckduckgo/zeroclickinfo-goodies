package DDG::Goodie::Dessert;
# ABSTRACT: find desserts starting with a given letter.

use strict;
use DDG::Goodie;
use utf8;
use warnings;
use strict;

zci answer_type => 'dessert';
# We add is_cached so that we get different results for the same query.
zci is_cached => 0;

triggers start => 'dessert', 'desserts', 'a dessert';

# This function picks a dessert from our lists.
sub itemify {
    # This has our list of desserts.
    my ($dessert_list, $end) = @_;

    my $i = rand scalar @{$dessert_list};
    my $dessert = $dessert_list->[$i];
    
    my $dessert_link = $dessert;
    $dessert_link =~ s/\s/+/g;
    
    return $dessert . $end,
    structured_answer => {
        id => 'dessert',
        name => 'Answer',
        data => {
            title => $dessert,
            subtitle => $end,
            url => "http://duckduckgo.com/?q=$dessert_link+recipe"
        },
        templates => {
            group => 'info',
        }
    };
};

# This is our list of desserts.
my %desserts = (
    a => ['Apple Turnover', 'Apple Almond Pancake', 'Amaretto Pumpkin Pie', 'Apple Ice Cream', 'Almond Banana Pie', 'Apricot Cherry Compote', 'Autumn Maple Cutout Cookies', 'Apricot Glaze'],
    b => ['Banana Split', 'Banana Fritters', 'Butterscotch Ice Cream', 'Baklava', 'Brazo de Mercedes', 'Black Forest Trifles', 'Brownie Pie', 'Bibingka', 'Button Cookies', 'Buttermilk Pancake'],
    c => ['Cherry Pie', 'Cupcake', 'Chocolate Sundae', 'Caramelized Apple Pie', 'Coffee Walnut Cake', 'Chiffon Cake', 'Cream Puffs', 'Cherry Crunch', 'Creme Brulee', 'Chocolate Mousse'],
    d => ['Dark Chocolate Souffle', 'Doughnut', 'Date Pudding', 'Date and Walnut Cookies', 'Double-Vanilla Meringue Cookies'],
    e => ['Eclair', 'Espresso Cake', 'Easter Bunny Cake', 'Espresso Meringue'],
    f => ['Froyo', 'Fudge Rolls', 'Fig and Honey Ice Cream', 'Fruit Salad', 'Frozen Mango Yogurt', 'Fuzzy Navel Cake', 'Fruit Bar', 'Fried Ice Cream', 'Fruit Flan', 'Fresh Cream Pineapple'],
    g => ['Gingerbread', 'Graham Cracker Pie', 'Gingery Plum Jam', 'Gingersnaps', 'Grilled Fruit Sundae', 'Gingerbread Biscotti'],
    h => ['Hazelnut Torte', 'Honey Nut Crunch', 'Heart-Shaped Napoleons', 'Honey Cinnamon Cake'],
    i => ['Ice Cream Sandwich', 'Irish Cream-Espresso Crème Caramel', 'Italian Chocolate Truffle', 'Italian Cake'],
    j => ['Jam roly-poly', 'Jelly Cake', 'Jam Crostata', 'Jam-Filled Cookies'],
    k => ['Key Lime Pie', 'Kiwi Cheesecake'],
    l => ['Lollipop', 'Liquorice', 'Lychee Sorbet', 'Lemon Fluff Pie', 'Linzer Cookies', 'Lemon Frozen Yogurt', 'Lemon Meringue Pie', 'Low-Fat Cherry Cobbler'],
    m => ['Macaroons', 'Meringues', 'Marshmallow', 'Morning Glory Muffins', 'Mango Pudding', 'Madeira Cake', 'Mango Fool', 'Mocha Parfait', 'Mint Fudge Tart', 'Marlborough Pie'],
    n => ['Nougat', 'Nutella', 'Nutty Graham Cake', 'New York Cheesecake', 'Noodle Pudding'],
    o => ['Oatmeal Pie', 'Oreos', 'Orange Muffins', 'Oreo Cookie Cheesecake', 'Orange Chiffon Cake', 'Olympic Gold Medal Cookies'],
    p => ['Profiteroles', 'Pumpkin Pie', 'Pineapple Cake', 'Pistachio Ice Cream', 'Peanut Butter Cupcakes', 'Plum Pudding', 'Pumpkin Fudge'],
    q => ['Quiche', 'Quinoa Apple Pie', 'Queen of Puddings', 'Quebec Sugar Pie'],
    r => ['Rocky Road','Red Velvet Cake','Rhubarb and Custard', 'Raisin Muffins', 'Raspberry Jam Hearts', 'Rainbow Cake', 'Rice Pudding', 'Rum Cake', 'Rugelach'],
    s => ['Sundae', 'Strudel', 'Strawberries and Cream', 'Soufflé', 'Sponge Cake', 'Strawberry Trifle', 'Sweet Potato Pudding', 'Stuffed Granny Smiths'],
    t => ['Tiramisu', 'Trifle', 'Twinkies', 'Taffy', 'Toffee Bars', 'Tropical Paradise Pancakes', 'Tangerine Creme Brulee', 'Tres Leches Cake', 'Tea Cake'],
    u => ['Upside-down cake', 'Unbaked Chocolate Cookies', 'Ultimate Chocolate Cake', 'Upside Down Orange Cake'],
    v => ['Vanilla Swirl', 'Valentine Cake', 'Vanilla Poached Peaches', 'Vanilla Pudding', 'Valentine Cupcakes'],
    w => ['Waffles','Watermelon','White Chocolate', 'Whole Wheat Muffins', 'Walnut Fudge', 'White Chocolate Snowflakes', 'Watermelon Pie'],
    x => ['Xmas Cake'],
    y => ['Yellow Layer Cake', 'Yogurt Fruit Pops', 'Yogurt Sundae', 'Yogurt Cheesecake'],
    z => ['Zeppole', 'Zucchini Cake', 'Zebra-Stripe Cheesecake'],
);

# This function checks if the query string matches the beginning of one of the desserts.
sub begins_with {
    my @items = ();
    my $query = shift;

    # We're getting the first letter, and we're going to use that as our key.
    # This should be faster since we don't go through every dessert in the hash.
    my $letter = lc substr($query, 0, 1);

    # Check if a value exists given our key.
    if(exists $desserts{$letter}) {
        my $value = $desserts{$letter};

        # Check if a certain dessert begins with our query string.
        for my $dessert (@{$value}) {
            if($dessert =~ /^$query/i) {
                push @items, $dessert;
            }
        }
    }

    return @items;
}

handle remainder => sub {
    # Ensure rand is seeded for each process
    srand();

    # Check the query. See if it matches this regular expression.
    if(lc $_ =~ m/^(?:that )?(?:start|beginn?)s?(?:ing)? (?:with)? (the letter )?([a-z].*)$/i) {
        # Check which desserts begin with this letter (or word).
        my @items = begins_with($2);

        # Check if we found any results.
        if(@items > 0) {
            return itemify(\@items, " is a dessert that begins with '$2'.");
        }
    }
    return;
};

1;
