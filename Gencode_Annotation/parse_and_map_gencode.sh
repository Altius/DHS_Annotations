#Parse Gencode and map to DHS Masterlist

module load bedops 


#Path to Gencode Annotation File
gunzip gencode.v28.basic.annotation.gtf.gz
gencode=gencode.v28.basic.annotation.gtf

#Path to DHS Masterlist 
dhs=DHS_Index.bed

#Remove row if start = end (only ~2K cases)
tail -n +6 $gencode \
| awk -F'\t' '{
    if($4 != $5) {
        print $1"\t"$4"\t"$5"\t"$3"\t"$7
    }
}' \
| /net/module/sw/bedops/2.4.37-typical/bin/sort-bed -  \
> tmp.gencode

#Expand the transcription region to say promoter. +/- 1KB of TSS
awk -F'\t' '{
        if($4 == "transcript") {
                if ($5 == "+") {
                        print $1"\t"$2"\t"$2+1000"\t""promoter";
                }
                else if ($5 == "-") {
                        print $1"\t"$3-1000"\t"$3"\t""promoter";
                }
    }
        else if($4 != "transcript") {
                print $1"\t"$2"\t"$3"\t"$4;
        }
}' tmp.gencode \
| grep -v chrM | grep -v Selenocysteine | grep -v codon \
| /net/module/sw/bedops/2.4.37-typical/bin/sort-bed - \
> tmp2.gencode

#Need to find the INTRONS. Difference between gene and (CDS + PROMOTER + UTR) 
awk '{if($4 == "gene") print}' tmp2.gencode > gene.bed4
awk '{if($4 == "exon") print}' tmp2.gencode > exon.bed4
awk '{if($4 == "CDS") print}' tmp2.gencode > cds.bed4
awk '{if($4 == "promoter") print}' tmp2.gencode > promoter.bed4
awk '{if($4 == "UTR") print}' tmp2.gencode > utr.bed4

bedops --ec -m utr.bed4 exon.bed4 promoter.bed4 cds.bed4 | bedops --ec -d gene.bed4 - > tmp.intron.bed4
awk '{print $1"\t"$2"\t"$3"\t""intron"}' tmp.intron.bed4 > intron.bed4

#Need to find the Intergenic region. Difference between Genome and gene body+promoter region
cat chromInfo.hg38.bed  \
| grep -v chrM > chromInfoNoM.hg38.bed
bedops --ec -d chromInfoNoM.hg38.bed gene.bed4 promoter.bed4 > tmp.intergenic.bed4
awk '{print $1"\t"$2"\t"$3"\t""intergenic"}' tmp.intergenic.bed4 > intergenic.bed4

#Clean Up
rm tmp.intron.bed4
rm tmp.intergenic.bed4

#First Plot
bedops --ec -u promoter.bed4 exon.bed4 intron.bed4 intergenic.bed4 | sort-bed - > gencode-genome.bed4
bedmap --ec --echo --echo-map --skip-unmapped --echo-overlap-size $dhs gencode-genome.bed4 > test.DHS-genome.bed
