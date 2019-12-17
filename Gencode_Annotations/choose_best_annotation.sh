#Choose the best annotation when multiple elements are mapped

biggest=0
col=0

#Replace annotation with ranked integer
sed 's/intergenic/1/g' test.DHS-genome.bed \
| sed 's/intron/2/g' \
| sed 's/exon/3/g' \
| sed 's/promoter/4/g' \
> choose_best.bed
awk -F'|' -v b=$biggest -v c=$col '{
        line=$3
        split(line,a,";")

        mapped=$2
        split(mapped,m,";")
        
    if (length(a) == 1) {
        print $1"\t"$2
    }
    else {
        for(i=1;i<=NF;i++) {
            if (a[i] > b) {
                b=a[i];
                c=i;
            }
            else if (a[i] == b) {
                old=m[c];
                split(old,o,"\t");
                new=m[i];
                split(new,n,"\t");
                if (o[4] < n[4]) {
                    b=a[i];
                    c=i;
                }
            }
        }
    print $1"\t"m[c];
    b=0;
    }

}'  choose_best.bed > overlap-answer.txt


#Replace ranking with Annotation
awk '{print $1"\t"$2"\t"$3"\t"$7}' overlap-answer.txt \
| sort-bed - \
| awk '{if($4 == 1) print $1"\t"$2"\t"$3"\t""intergenic"; else if($4 == 2) print $1"\t"$2"\t"$3"\t""intron"; else if($4 == 3) print $1"\t"$2"\t"$3"\t""exon"; else if($4 == 4) print $1"\t"$2"\t"$3"\t""promoter"}' - \
> dhs_annotated_gencode28.bed
