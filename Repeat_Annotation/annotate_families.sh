#Annotate Family Repeats

###Find the distribution of family repeats
#SINE -> Alu, MIR, and Others
#LTR -> ERVL-MaLR, ERV1, ERVL, Others
#DNA -> hAT-Charlie, TcMar-Tigger, Others
#LINE -> L1, L2, Others

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

#LTR -> ERVL-MaLR, ERV1, ERVL, Others
awk '{if($5 != "ERVL-MaLR" &&  $5 != "ERV1" && $5 != "ERVL") {
        print $1"\t"$2"\t"$3"\t"$4"\t""Others"; 
        }
        
        else {
        print $1"\t"$2"\t"$3"\t"$4"\t"$5;
        }
}' tmp.LTR.bed > LTR.bed

#DNA -> hAT-Charlie, TcMar-Tigger, Others
awk '{if($5 != "hAT-Charlie" &&  $5 != "TcMar-Tigger") {
        print $1"\t"$2"\t"$3"\t"$4"\t""Others"; 
        }
        
        else {
        print $1"\t"$2"\t"$3"\t"$4"\t"$5;
        }
}' tmp.DNA.bed > DNA.bed

#LINE -> L1, L2, Others
awk '{if($5 != "L1" &&  $5 != "L2") {
        print $1"\t"$2"\t"$3"\t"$4"\t""Others"; 
        }
        
        else {
        print $1"\t"$2"\t"$3"\t"$4"\t"$5;
        }
}' tmp.LINE.bed > LINE.bed



#Clean Up
rm tmp.*

