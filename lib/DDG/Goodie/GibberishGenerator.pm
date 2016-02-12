package DDG::Goodie::GibberishGenerator;
# ABSTRACT: generates random gibberish

use strict;
use DDG::Goodie;
use utf8;

use Silly::Werder qw(sentence get_werd);
use Lingua::EN::Numericalize;

triggers any => qw(nonsense gibberish);

zci is_cached => 0;
zci answer_type => "gibberish_generator";

my %languages = (
    'english'       => ['English', 'small'],
    'german'        => ['German',  ''],
    'french'        => ['French',  ''],
    'shakespearean' => ['Shakespeare', ''],
    'swedish'       => ['Swedish', ''],
);

sub pluralise {
    my ($amount, $to_pluralise) = @_;
    return $amount == 1 ? $to_pluralise : ($to_pluralise . 's');
}

my $types       = qr/(?<type>word|sentence|line)/i;
my $modifier_re = qr/(?<modifier>English|German|French|Swedish|Shakespearean)/i;
my $amountre    = qr/(?<amount>\d+)/;
my $nonsense_re = qr/(?:nonsense|gibberish)/i;

my $forms = qr/^(?:
     (((?<amount>\d+)\s)?($types)s?\sof((?!$modifier_re).)*(?<modifier>$modifier_re)?+.*($nonsense_re))
    |((?<amount>\d+)\s(?<modifier>$modifier_re)?\s*($nonsense_re)\s($types)s?)
    )$/xi;


# Generates a string containing all the nonsense words/sentences.
sub generate_werds {
    my ($amount, $modifier, $type) = @_;
    my @modifier_args = @{$languages{$modifier}};

    my $werd = Silly::Werder->new();
    $werd->set_language(@modifier_args);
    my $werds;
    if ($type eq 'sentence') {
        $werds = join ' ', map { $werd->sentence() } (1..$amount);
    } elsif ($type eq 'word') {
        $werd->set_werds_num($amount, $amount);
        $werds = $werd->sentence();
    } elsif ($type eq 'line') {
        $werds = join "\n", map { $werd->line() } (1..$amount);
    };
    return $werds;
}

sub get_approximate_amount_werds {
    my ($num, $type) = @_;
    return $num if $type eq 'word';
    return $num * 8 if $type eq 'sentence';
    return $num * 8 if $type eq 'line';
}

handle query_lc => sub {
    my $query   = $_;
    # Treat 'a' as 'one' for the purposes of amounts.
    $query =~ s/^a /one /i;
    # Convert initial words into numbers if possible.
    my $formatted = $query =~ s/^\w+[a-rt-z](?=\b)/str2nbr($&)/ier;
    return unless $formatted =~ $forms;
    my $amount   = $+{'amount'} // 1;
    my $modifier = $+{'modifier'} // 'english';
    my $type     = $+{'type'};
    return if get_approximate_amount_werds($amount, $type) > 200;
    my $result = generate_werds($amount, $modifier, $type);
    # Proper-case modifier (english -> English)
    my $fmodifier = $modifier =~ s/^\w/\u$&/r;
    # E.g, "3 words of Swedish gibberish"
    my $formatted_input = "$amount @{[pluralise $amount, $type]} of $fmodifier gibberish";
    my @paragraphs = split "\n", $result;

    return $result, structured_answer => {
        id   => 'gibberish_generator',
        name => 'Answer',
        data => {
            title                => "$formatted_input",
            gibberish_paragraphs => \@paragraphs,
            use_paragraphs       => $#paragraphs ? 1 : 0,
        },
        templates => {
            group   => 'info',
            options => {
                moreAt       => 0,
                content      => 'DDH.gibberish_generator.content',
                chompContent => 1,
            }
        }
    };
};

1;
