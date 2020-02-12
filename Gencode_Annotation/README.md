# DHS_Gencode_Annotation
Annotating the DHS Masterlist with Gencode

## Steps
1. Download Gencode Annotation file and DHS Masterlist file
2. Parse Gencode file and create bed files for gene body, exon, cds , promoter, utr, intronic, and intergenic
3. Map promoter, exon, intronic, and intergenic regions to DHS Masterlist
4. Annotate the DHS as promoter, exon, intron, or intergenic depending on which element had the largest overlap. If there is a tie in overlap, the winning annotation is based on the rank
5. For CDS and UTR under exon, pick the element that has the largest overlap. If there was a tie, pick the largest fraction of overlap
6. For Protein-Coding and Non-Protein-Coding under promoter/intronic, pick the element that has the largest overlap. If there was a tie, pick the largest fraction of overlap

## Download Gencode Annotation File
* Go to [Gencode Release 28](https://www.gencodegenes.org/human/release_28.html)
* Scroll down to *Basic Gene Annotation* (Regions: CHR) 
* Download the GTF version 


## Download DHS Masterlist
* Go to [DHS Masterlist](https://zenodo.org/record/3542126#.XffhGZNKgWp)

Download DHS_Index_and_Vocabulary_hg38_WM20190703.txt.gz


## Complete the rest of the annotation with Gencode-Annotation.sh.ipynb

#### Written description of steps outlined in Gencode-Annotation.sh.ipynb

## Parse Gencode and map to DHS Masterlist

1. From gencode.v28.basic.annotation.gtf, removed rows when start coordinate = end coordinate (2K cases) and when gencode annotation was “Selenocysteine” or “codon”.
2. When gencode annotation was “transcript”, we labeled +/- 1kb of TSS as promoter.
3. Create bed files for gene body, exon, cds, promoter, utr, intronic, and intergenic
4. Merge promoter, exon, intronic, and intergenic bed files and name gencode-genome.bed
5. Map gencode-genome.bed with DHS Masterlist

Notes: 

- Intron is the difference between the gene body and (utr+exon+promoter+cds)
- Intergenic is the difference between chromInfo.bed and (gene body + promoter)

Need:
> DHS Masterlist, gencode.v28.basic.annotation.gtf, and chromInfo.hg38.bed

## Choose Best Annotation

1. Rank the elements. Promoter > Exon > Intron > Intergenic.
2. Choose the best annotation based on overlap count. If two elements have the same overlap count, the winning element is chosen by its rank

*Resulting file will be named: dhs_annotated_gencode28.bed*


## Parse Gencode File to seperate into Protein-Coding and Non-Protein-Coding regions
* Remember to remove rows with same start and end coordinates

Notes:
- NPC = non-coding
- PC = protein-coding


## Split Exon annotated DHSs to CDS, UTR, and non-coding

1. Extract Exonic regions from DHS Annotation
2. Extract UTR and CDS labeled regions from gencode 
3. Map UTR/CDS regions to Exonic DHS Annotations
4. Pick element with the largest overlap. If there is a tie, pick the element with the largest fraction of overlap
5. If Exonic DHS was not annotated as UTR or CDS then annotated the DHS as non-coding (NPC)

## Split Promoter annotated DHSs to coding-gene and non-coding

1. Extract Promoter regions from DHS Annotation
2. Map protein-coding/non-coding gencode regions to Promoter DHS Annotations
4. Pick element with the largest overlap. If there is a tie, pick the element with the largest fraction of overlap

## Split Intronic annotated DHSs to coding-gene and non-coding

1. Extract Intronic regions from DHS Annotation 
2. Map protein-coding/non-coding gencode regions to Intronic DHS Annotations
4. Pick element with the largest overlap. If there is a tie, pick the element with the largest fraction of overlap


## Results Directory 

- DHS Masterlist annotated as promoter, exon, intron, or intergenic = results/dhs_annotated_gencode28.bed
- Promoter annotated DHSs as coding or non-coding = results/dhs_annotated_promoter.bed
- Exon annotated DHSs as UTR, CDS, or non-coding = results/dhs_annotated_exon.bed
- Intron annotated DHSs as coding or non-coding = results/dhs_annotated_intron.bed


