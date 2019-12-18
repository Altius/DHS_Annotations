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

}'  repeats_mapped_with_overlapPlusExtra.bed  > overlap-answer.txt


awk '{print $1"\t"$2"\t"$3"\t"$9"\t"$10}' overlap-answer.txt \
| sort-bed - \
> dhs_annotated_all-repeats.bed

#Create 7 Groups. 6 with original Repeat names and the last one "Others"
awk '{
        if ($4 != "SINE" && $4 != "LINE" && $4 != "LTR" && $4 != "Simple_repeat" && $4 != "DNA" && $4 != "Low_complexity") {
                print $1"\t"$2"\t"$3"\t""Others""\t""Others";
        }
        else {
                print;
        }
}' dhs_annotated_all-repeats.bed > dhs_annotated_7-repeats.bed

#Clean-up
mkdir extra_files
mv repeats_mapped_with_overlapPlusExtra.bed extra_files/
mv DHS_Index.bed extra_files/
mv overlap-answer.txt extra_files
mv dhs_annotated_all-repeats.bed extra_files
