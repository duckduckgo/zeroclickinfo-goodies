#package DDG::Goodie::<: $ia_package_name :>;
# ABSTRACT: Write an abstract here
# Start at https://duck.co/duckduckhack/goodie_overview if you are new
# to instant answer development

use DDG::Goodie;

zci answer_type => "<: $lia_name :>";
zci is_cached   => 1;

# Metadata.  See https://duck.co/duckduckhack/metadata for help in filling out this section.
name "<: $ia_name_separated :>";
description "Succinct explanation of what this instant answer does";
primary_example_queries "first example query", "second example query";
secondary_example_queries "optional -- demonstrate any additional triggers";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#category
# category "";
# Uncomment and complete: https://duck.co/duckduckhack/metadata#topics
# topics "";
code_url "https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/<: $ia_path :>.pm";
attribution github => ["GitHubAccount", "Friendly Name"],
            twitter => "twitterhandle";

# Triggers
triggers any => "triggerWord", "trigger phrase";

# Handle statement
handle remainder => sub {

    my $input = $_;

    # optional - regex guard
    # return unless $input =~ /^\w+/;

    return unless $input; # Guard against "no answer"

    # Create your result
    my $result = "result";

    return $result,
      structured_answer => {
        input     => [$input],
        operation => 'what did this thing do?',
        result    => $result
      };
};



1;
