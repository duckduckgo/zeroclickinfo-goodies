
# Takes two numbers and does a bitwise exclusive-or on them.

if (!$type && $q_check =~ m/^(\d+) *(xor|⊕) *(\d+)$/i) {
    
    if ($2 && $3) {
        $answer_results = ord(chr($1)^chr($3));
    }
    
    if ($answer_results) {
        $answer_results = qq($1 xor $3 = $answer_results);
        $answer_type = 'xor';
        $type = 'E';
        }
}
