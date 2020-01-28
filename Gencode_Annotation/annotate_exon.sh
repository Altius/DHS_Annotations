#Split Annotated Exon DHSs into CDS, UTR, and non-coding

module load bedops

#Path to Gencode Annotation File
gencode=gencode.v28.basic.annotation.gtf

#Path to DHS Masterlist Annotation
dhs=dhs_annotated_gencode28.bed

tail -n +6 $gencode \
| awk -F'\t' '{
        if($4 != $5) {
                print $1"\t"$4"\t"$5"\t"$3;
        }
}' \
| sort-bed - \
> tmp.gencode


#Map
awk '{if($4 == "exon") print}' $dhs > dhs-exon.bed

awk '{if($4 == "UTR") print}' tmp.gencode > utr.bed
awk '{if($4 == "CDS") print}' tmp.gencode > cds.bed
bedops -u utr.bed cds.bed > utr-cds-gencode.bed



bedmap --echo --echo-map --echo-overlap-size --echo-map-size --skip-unmapped --ec dhs-exon.bed  utr-cds-gencode.bed \
> dhs_mapped_with_overlapPlusExtra.bed


#Choose the element with the largest overlap or the largest fraction of overlap

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
> dhs_annotated_exon.bed
