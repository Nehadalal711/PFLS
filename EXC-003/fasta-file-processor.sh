# Calculate num_seqs
num_seqs=$(grep -c '>' $1)
#total length without def line
total_length=$(awk '/^>/ {next} {total_length += length $0} END{print total_length}' $1)
#sorting and calculating longest sequence length
longest_seq=$(awk '/^>/ {if (seqlen) {print seqlen} (seqlen = 0);next} { seqlen += length $0} END{print seqlen}' "$1" | sort -n | tail -n 1)
# shortest seq length
shortest_seq=$(awk '/^>/ {if (seqlen) {print seqlen} (seqlen = 0); next} { seqlen += length $0} END{print seqlen}' $1 | sort -n | head -n 1)
#average length
avg_length=$(($total_length/$num_seqs))
# gc
gc_c=$(grep -v '^>' $1 | awk '{gc_count += gsub(/[GgCc]/, "", $1)} END{print gc_count}')


gc_content=$(echo "scale=2; ($gc_c/$total_length)*100" | bc)







echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: $num_seqs"
echo "Total length of sequences: $total_length"
echo "Length of the longest sequence: $longest_seq"
echo "Length of the shortest sequence: $shortest_seq"
echo "Average sequence length: $avg_length"
echo "GC Content (%): $gc_content"