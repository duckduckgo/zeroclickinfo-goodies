package DDG::Goodie::LoremIpsum;
# ABSTRACT: generates random latin

use strict;
use DDG::Goodie;
use utf8;

use Text::Lorem::More;
use Lingua::EN::Numericalize;

triggers any => 'lorem ipsum', 'lipsum', 'latin';

zci is_cached => 0;
zci answer_type => 'lorem_ipsum';

sub pluralise {
    my ($amount, $to_pluralise) = @_;
    return $amount == 1 ? $to_pluralise : ($to_pluralise . 's');
}

my $types       = qr/(?<type>word|sentence|paragraph)/i;
my $modifier_re = qr/(?<modifier>random|regular)/i;
my $amountre    = qr/(?<amount>\d+)/;
my $lorem_re = qr/(?:latin|l(?:orem )?ipsum)/i;

my $forms = qr/^(?:
     (((?<amount>\d+)\s)?($types)s?\sof((?!$modifier_re).)*(?<modifier>$modifier_re)?+.*($lorem_re))
    |((?<amount>\d+)\s(?<modifier>$modifier_re)?\s*($lorem_re)\s($types)s?)
    )$/xi;


# Generates a string containing all the nonsense words/sentences.
sub generate_latin {
    my ($amount, $modifier, $type) = @_;
    my $word = Text::Lorem::More->new();
    my $words;
    if ($type eq 'sentence') {
        $words = $word->sentences($amount);
    } elsif ($type eq 'word') {
        $words = $word->words($amount);
    } elsif ($type eq 'paragraph') {
        $words = $word->paragraphs($amount);
    };
    return $words;
}

sub get_result_and_formatted {
    my $query = shift;
    $query =~ s/^a /one /i;
    # Convert initial words into numbers if possible.
    my $formatted = $query =~ s/^\w+[a-rt-z](?=\b)/str2nbr($&)/ier;
    return unless $formatted =~ $forms;
    my $amount   = $+{'amount'} // 1;
    my $modifier = $+{'modifier'} // 'regular';
    my $type     = $+{'type'};
    my $result = generate_latin($amount, $modifier, $type);
    # Proper-case modifier (latin -> Latin)
    my $fmodifier = $modifier =~ s/^\w/\u$&/r;
    # E.g, "3 words of lorem ipsum"
    my $formatted_input = "$amount @{[pluralise $amount, $type]} of Lorem Ipsum";
    return ($result, $formatted_input);
}

sub build_infobox_element {
    my $query = shift;
    my @split = split ' ', $query;
    return {
        label => $query,
        url   => 'https://duckduckgo.com/?q=' . (join '+', @split) . '&ia=answer',
    };
}

handle query_lc => sub {
    my $query   = $_;
    # Treat 'a' as 'one' for the purposes of amounts.
    $query =~ s/line/sentence/g;
    my $default = 0;
    my $result = '';
    my $amount = 0;
    my $formatted_input;
    if ($query =~ /^\s*l(orem )?ipsum\s*$/) {
        $default = 1;
        $result = Text::Lorem::More->new->paragraphs(5);
        $formatted_input = "5 paragraphs of Lorem Ipsum";
    } else {
        ($result, $formatted_input) = get_result_and_formatted($query) or return;
    };
    my @paragraphs = split "\n\n", $result;

    return $result, structured_answer => {
        id   => 'lorem_ipsum',
        name => 'Answer',
        data => {
            title            => "$formatted_input",
            lorem_paragraphs => \@paragraphs,
            infoboxData      => $default ? [
                { heading => "Example Queries", },
                build_infobox_element('5 sentences of lorem ipsum'),
                build_infobox_element('20 words of random latin'),
                build_infobox_element('10 paragraphs of lorem ipsum'),
            ] : 0,
        },
        meta => {
            sourceName => "Lipsum",
            sourceUrl  => "http://lipsum.com/"
        },
        templates => {
            group   => 'info',
            options => {
                moreAt       => 1,
                content      => 'DDH.lorem_ipsum.content',
                chompContent => 1,
            }
        }
    };
};

1;
