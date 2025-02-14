
# Create the output directory
COMBINED_DIR="COMBINED-DATA"
mkdir -p "$COMBINED_DIR"

# Process each sample directory in RAW-DATA
for g in $(ls -d RAW-DATA/*/)
do
    Sample_names=$(basename "$g")
    Culture=$(awk -v s="$Sample_names" '$1 == s {print $2}' RAW-DATA/sample-translation.txt)

    # Initialize counters for MAG and BIN
    MAG_COUNT=1
    BIN_COUNT=1

    # Path to CheckM and GTDB files
    Checkm_file="${g}checkm.txt"
    GTDB_file="${g}gtdb.gtdbtk.tax"

    # Copy CheckM and GTDB files to COMBINED-DATA
        cp "$Checkm_file" "$COMBINED_DIR/$Culture-CHECKM.txt"
        cp "$GTDB_file" "$COMBINED_DIR/$Culture-GTDB-TAX.txt"
    

    # Process FASTA files in the `bins/` directory
    for fasta_file in "$g/bins/"*.fasta
     do
        file_name=$(basename "$fasta_file" | awk 'BEGIN{FS="."} {print $1}')
    

        # Skip "bin-unbinned.fasta" but copy it as `XXX_UNBINNED.fa`
        if [[ "$file_name" == "bin-unbinned.fasta" ]]
         then
            cp "$fasta_file" "$COMBINED_DIR/${Culture}_UNBINNED.fa"
            continue
        fi

        # Extract Completeness and Contamination
      
            Completeness=$(awk -v f="$file_name" '$0 ~ f {print $13}' "$Checkm_file")
            Completeness_int=$(echo "$Completeness" | awk -F"." '{print $1}')


            Contamination=$(awk -v f="$file_name" '$0 ~ f {print $14}' "$Checkm_file")
            Contamination_int=$(echo "$Contamination" | awk -F"." '{print $1}')

    


            # Conditional check for MAG and BIN
            if [[ $Completeness_int -ge 50 && $Contamination_int -lt 5 ]]
            then
                YYY="MAG"
            
            else
                YYY="BIN"  
            fi
         

        # Assign sequential number for MAG or BIN
        if [[ "$YYY" == "MAG" ]]; then
            ZZZ=$(printf "%03d" $MAG_COUNT)  # Zero-padded MAG number
            MAG_COUNT=$((MAG_COUNT + 1))  # Increment MAG count
        elif [[ "$YYY" == "BIN" ]]; then
            ZZZ=$(printf "%03d" $BIN_COUNT)  # Zero-padded BIN number
            BIN_COUNT=$((BIN_COUNT + 1))  # Increment BIN count
        fi

        # Construct the new filename and copy the file
        NEW_NAME="${Culture}_${YYY}_${ZZZ}.fa"

        # Copy the file directly to COMBINED-DATA
        cp "$fasta_file" "$COMBINED_DIR/$NEW_NAME"

        sed -i "s/>bin/>${Culture}/g" "$COMBINED_DIR/$NEW_NAME"

    done
done
echo "YOU ARE GOLDEN :) "
