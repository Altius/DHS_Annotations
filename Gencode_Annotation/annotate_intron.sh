#Split Intronic annotated DHSs to coding-gene and non-coding

module load bedops
genePart="intron"

#Path to Gencode Annotation File
gencode=gencode.v28.basic.annotation.gtf

#Path to DHS Masterlist 
dhs=dhs_annotated_gencode28.bed

tail -n +6 $gencode \
| awk -F'\t' '{
        if($4 != $5) {
                print $1"\t"$4"\t"$5"\t"$3"\t"$9;
        }
}' \
| sort-bed - \
> tmp.gencode


#Map PC/NPC regions to Intronic DHSs
awk -F'\t' '{if($4 == "intron") print}' $dhs > dhs-intron.bed

grep protein_coding tmp.gencode \
| awk '{print $1"\t"$2"\t"$3"\t""PC"}' - > PC.bed

grep -v protein_coding tmp.gencode \
| awk '{print $1"\t"$2"\t"$3"\t""NPC"}'> NPC.bed

bedops -u PC.bed NPC.bed > PC-NPC-gencode.bed

bedmap --echo --echo-map --echo-overlap-size --echo-map-size --skip-unmapped --ec dhs-${genePart}.bed PC-NPC-gencode.bed \
> dhs_mapped_with_overlapPlusExtra.bed

biggest=0
col=0
fraction=0

awk -F'|' -v f=$fraction -v b=$biggest -v c=$col '{
        line=$3
        split(line,a,";")

        mapped=$2
        split(mapped,m,";")

        size=$4
        split(size,s,";")
        
        if (length(a) == 1) {
                c=1;
        }
        else {
                for(i=1;i<=NF;i++) {
                        if (a[i] > b) {
                                b=a[i];
                                c=i;
                                f=a[i]/s[i];
                        }
                        else if (a[i] == b) {
                                if(a[i]/s[i] > f) {
                                        b=a[i];
                                        c=i;
                                }
                        } 
                }      
        }
        print $1"\t"m[c];
        b=0;      

}' dhs_mapped_with_overlapPlusExtra.bed > overlap-answer.txt

awk '{print $1"\t"$2"\t"$3"\t"$4"\t"$8}' overlap-answer.txt \
| sort-bed - \
> dhs_annotated_${genePart}.bed
