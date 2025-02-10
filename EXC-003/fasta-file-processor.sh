# Calculate num_seqs
num_seqs=$(grep -c '>' $1)
total_length=$(grep -v '>' $1 | wc -c)
longest_seq=$(awk '/^>/ {if (seqlen) {print seqlen} (seqlen = 0);next} { seqlen += length $0} END{print seqlen}' "$1" | sort -n | tail -n 1)
shortest_seq=$(awk '/^>/ {if (seqlen) {print seqlen} (seqlen = 0); next} { seqlen += length $0} END{print seqlen}' $1 | sort -n | head -n 1)
avg_length=$(($total_length/$num_seqs))
gc_content=$( grep -v '^>' $1 | awk '{gc_count += gsub(/[GgCc]/, "", $1)} END {print gc_count}' | (100* $gc_count/$total_length))

echo"$gc_content"









echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_seqs"
echo "Total length of sequences: $total_length"
echo "Length of the longest sequence: $longest_seq"
echo "Length of the shortest sequence: $shortest_seq"
echo "Average sequence length: $avg_length"
echo "GC Content (%): $gc_content"