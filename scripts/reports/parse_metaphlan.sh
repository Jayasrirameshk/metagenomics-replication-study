#!/bin/bash
taxonomy=$1
input_path="/Users/jayasriramesh/Downloads/outputs/metaphlan4"
if [[ -z "$taxonomy" ]]; then
    echo "Usage: $0 <taxonomy_rank>"
    echo "Valid ranks: phylum, class, order, family, genus, species, strain"
    exit 1
fi

echo -e "sampleID\tname\tcounts\trelabundance" > metaphlan4_${taxonomy}.txt

if [[ $taxonomy == phylum ]]; then
    prefix="p__"
    pipes=1
fi
if [[ $taxonomy == class ]]; then
    prefix="c__"
    pipes=2
fi
if [[ $taxonomy == order ]]; then
    prefix="o__"
    pipes=3
fi
if [[ $taxonomy == family ]]; then
    prefix="f__"
    pipes=4
fi
if [[ $taxonomy == genus ]]; then
    prefix="g__"
    pipes=5
fi
if [[ $taxonomy == species ]]; then
    prefix="s__"
    pipes=6
fi
if [[ $taxonomy == strain ]]; then
    prefix="t__"
    pipes=7
fi

for file in ${input_path}/*_profile.txt; do
    sample_id=$(basename "$file" _profile.txt)
    
    grep -v "^#" "$file" | grep "${prefix}" | while IFS=$'\t' read -r clade_name tax_id rel_abundance additional; do
        # Count pipes to ensure correct taxonomic level
        pipe_count=$(echo "$clade_name" | tr -cd '|' | wc -c)
        
        if [[ $pipe_count -eq $pipes ]]; then
            # Extract only the taxon name (remove the prefix)
            taxon=$(echo "$clade_name" | awk -F'|' '{print $NF}' | sed "s/${prefix}//")
            
            # Skip if taxon is empty
            if [[ -n "$taxon" ]]; then
                counts="$rel_abundance"
                relabundance=$(echo "$rel_abundance" | awk '{print $1/100}')
                
                echo -e "${sample_id}\t${taxon}\t${counts}\t${relabundance}" >> metaphlan4_${taxonomy}.txt
            fi
        fi
    done
done

