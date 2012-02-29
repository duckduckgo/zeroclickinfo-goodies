
# Takes given numbers and does a bitwise exclusive-or on them.

if (!$type && $q_check =~ m/^[0-9]+\s*(\s+(xor|⊕)\s*[0-9]+)+\s*$/i) {
    
    my $num = 0;
    my @numbers = grep(!/(xor|⊕)/, split(/\s+(xor|⊕)\s+/, $q_check));
    foreach (@numbers) {
        $num ^= ord(chr($_)); 
    }
    $answer_results = qq(Answer: <a href="javascript:;" onclick="document.x.q.value='$num';document.x.q.focus();">$num</a>);
    if ($answer_results) {
        $answer_type = 'xor';
        $type = 'E';
    }
}
