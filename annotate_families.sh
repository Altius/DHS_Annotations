#Annotate Family Repeats

###Find the distribution of family repeats
#SINE -> Alu, MIR, and Others
#LTR -> ERVL-MaLR, ERV1, ERVL, Others
#DNA -> hAT-Charlie, TcMar-Tigger, Others
#LINE -> L1, L2, Others

mkdir -p /home/nasi4/proj/encode3/DHS_Annotations/Repeated_Regions/results_streamline/families
wdir=/home/nasi4/proj/encode3/DHS_Annotations/Repeated_Regions/results_streamline/families
cd $wdir

file=/home/nasi4/proj/encode3/DHS_Annotations/Repeated_Regions/results_streamline/dhs_annotated_7-repeats.bed


#Split $file into the four classes that have familes
for i in SINE LINE LTR DNA
do
        awk -v class="$i" '{if($4 == class) print}' $file > tmp.${i}.bed
done


awk '{if($5 != "Alu" &&  $5 != "MIR") {
        print $1"\t"$2"\t"$3"\t"$4"\t""Others"; 
        }
        
        else {
        print $1"\t"$2"\t"$3"\t"$4"\t"$5;
        }
}' tmp.SINE.bed > SINE.bed

