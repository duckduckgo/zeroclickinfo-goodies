package DDG::Goodie::Reverse;
# ABSTRACT: Reverse the order of chars in the remainder

use DDG::Goodie;

primary_example_queries 'reverse text esrever';
description 'reverse the order of the characters in your query';
name 'Reverse';
code_url 'https://github.com/duckduckgo/zeroclickinfo-goodies/blob/master/lib/DDG/Goodie/Reverse.pm';
category 'transformations';
topics 'words_and_games';

attribution github => ['https://github.com/Getty', 'Torsten Raudssus'], 
            cpan => ['GETTY', 'Torsten Raudssus'];

triggers startend => "reverse text";

zci answer_type => "reverse";
zci is_cached   => 1;

handle remainder => sub {
  my $in = $_;

  return unless $in;    # Guard against empty query.
  #Filter out requests for DNA/RNA reverse complements, handled
  # by the ReverseComplement goodie
  return if $in =~ /^complement\s(of )?[ATCGURYKMSWBVDHN\s-]+$/i;

  my $out = reverse $in;

  return qq|Reversed "$_": | . $out,
    structured_answer => {
      input     => [html_enc($in)],
      operation => 'Reverse string',
      result    => html_enc($out),
    };
};

1;
