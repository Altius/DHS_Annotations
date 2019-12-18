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

```
gunzip DHS_Index_and_Vocabulary_hg38_WM20190703.txt.gz
cut -f1-3 DHS_Index_and_Vocabulary_hg38_WM20190703.txt \
| tail -n +2 \
> DHS_Index.bed
```

# Parse Gencode and map to DHS Masterlist

1. From gencode.v28.basic.annotation.gtf, removed rows when start coordinate = end coordinate (2K cases) and when gencode annotation was “Selenocysteine” or “codon”.
2. When gencode annotation was “transcript”, we labeled +/- 1kb of TSS as promoter.
3. Create bed files for gene body, exon, cds, promoter, utr, intronic, and intergenic
4. Merge promoter, exon, intronic, and intergenic bed files and name gencode-genome.bed4
5. Map gencode-genome.bed4 with DHS Masterlist

Notes: 

- Intron is the difference between the gene body and (utr+exon+promoter+cds)
- Intergenic is the difference between chromInfo.bed and (gene body + promoter)

Need:
> DHS Masterlist, gencode.v28.basic.annotation.gtf, and chromInfo.hg38.bed

Run
```
parse_and_map_gencode.sh
```

**In test.DHS-genome.bed, multiple mapped elements will be seperated by a semicolon**

Output:

<table>
<tr><th>gencode-genome.bed4 </th><th>test.DHS-genome.bed</th></tr>
<tr><td>

| chr   | gencodeStart | gencodeEnd | gencodeElement  | 
| ------------- | ------------- | ------------- | ------------- |
| chr1  | 0 | 11869 | intergenic  | | 34  | 45  |
| chr1  | 11869 | 12227 | exon    |
| chr1  | 11869 | 12869 | promoter    |
| chr1  | 12010 | 12057 | exon    |
| chr1  | 12010 | 13010 | promoter    |

</td><td>
  

| chr   |   dhsStart   | dhsEnd | chr | gencodeStart  | gencodeEnd  | gencodeElement  | overlap |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1  | 51868 | 52040 | chr1  | 36081 | 52473 | intergenic  | 172  |
| chr1  | 57280 | 57354 |  chr1  | 53473 | 57598 | intergenic  | 74 |
| chr1  | 79100 |79231 |  chr1  | 71585 | 89295 | intergenic| 131 |
| chr1  | 139352  | 139421  | chr1  | 139339  | 140339  | promoter  | 69 |
| chr1  | 729346  | 729440  | chr1 | 725885  | 729804  | exon  | 94  |


</td></tr> </table>


# Choose Best Annotation

1. Rank the elements. Promoter > Exon > Intron > Intergenic.
2. Annotate DHS Masterlist
3. If two elements have the same overlap count, the winning element is chosen based on the rank

Need:
> test.DHS-genome.bed

Run
```
choose_best_annotation.sh
```

Output:

<table>
<tr><th>gencode-genome.bed4 </th><th>test.DHS-genome.bed</th></tr>
<tr><td>

| chr | dhsStart  | dhsEnd  | gencodeElement  |
| ------------- | ------------- | ------------- | ------------- |
| chr1  | 16140 | 16200 | intron  |
| chr1  | 51868 | 52040 | intergenic  |
| chr1  | 57280 | 57354 |intergenic |
| chr1  | 139352  | 139421  | promoter  |
| chr1  | 729346  | 729440 | exon  |

</td><td>

| Region  | DHSCount  |
| ------------- | ------------- |
| exon  | 158527  |
| intergenic  | 1376951 |
| intron  | 1891595 | 
| promoter  | 164825 | 
| Total | 3591898 |

</td></tr> </table>

# Split Exon annotated DHSs to CDS, UTR, and non-coding

1. Extract Exonic regions from DHS Annotation
2. Extract UTR and CDS labeled regions from gencode 
3. Map UTR/CDS regions to Exonic DHS Annotations
4. Pick element with the largest overlap. If there is a tie, pick the element with the largest fraction of overlap

Need:
> gencode.v28.basic.annotation.gtf and dhs_annotated_gencode28.bed

Run
```
annotate_exon.sh
```

Output:

<table>
<tr><th>dhs_annotated_exon.bed </th><th>DHS Counts</th></tr>
<tr><td>

| chr | dhsStart  | dhsEnd  | gencodeElement  | gencodeSubElement |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1  | 935890  | 936080  | exon  | CDS |
| chr1	| 939198	| 939366	| exon	| CDS |
| chr1	| 939440	| 939680	| exon	| CDS |
| chr1	| 941140	| 941361	| exon	| CDS |
| chr1	| 941140	| 941620	| exon	| CDS |

</td><td>
  
| Region  | DHSCount  |
| ------------- | ------------- |
| CDS | 68648 |
| UTR | 60908 |
| Total | 3591898 |

</td></tr> </table>

# Split Promoter annotated DHSs to coding-gene and non-coding

1. Extract Promoter regions from DHS Annotation
2. Extract protein-coding labeled regions from gencode 
3. Map protein-coding/non-coding gencode regions to Promoter DHS Annotations
4. Pick element with the largest overlap. If there is a tie, pick the element with the largest fraction of overlap

Notes:
- NPC = non-coding
- PC = protein-coding

Need:
> gencode.v28.basic.annotation.gtf and dhs_annotated_gencode28.bed


Run
```
annotate_promoter.sh
```

Output:

<table>
<tr><th>dhs_annotated_promoter.bed</th><th>DHS Counts</th></tr>
<tr><td>

| chr | dhsStart  | dhsEnd  | gencodeElement  | gencodeSubElement |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1  | 90140 | 90209 | promoter  | NPC |
| chr1	| 135100  |	135144  |	promoter  |	NPC |
| chr1	| 182681  |	182819  |	promoter  |	NPC |
| chr1	| 186960  |	187129  | promoter  |	NPC |
| chr1  | 629100	| 629280  |	promoter  |	NPC |

</td><td>
 
| Region  | DHSCount  |
| ------------- | ------------- |
| NPC | 47219 |
| PC  | 112242  | 
| Total | 3591898 |

</td></tr> </table>

# Split Intronic annotated DHSs to coding-gene and non-coding

1. Extract Intronic regions from DHS Annotation
2. Extract protein-coding labeled regions from gencode 
3. Map protein-coding/non-coding gencode regions to Intronic DHS Annotations
4. Pick element with the largest overlap. If there is a tie, pick the element with the largest fraction of overlap

Notes:
- NPC = non-coding
- PC = protein-coding

Need:
> gencode.v28.basic.annotation.gtf and dhs_annotated_gencode28.bed


Run
```
annotate_intron.sh
```

Output:

<table>
<tr><th>dhs_annotated_intron.bed </th><th>DHS Counts</th></tr>
<tr><td>

| chr | dhsStart  | dhsEnd  | gencodeElement  | gencodeSubElement |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1  | 16140 | 16200 | intron  | NPC |
| chr1  | 66370 | 66482 | intron  | PC  |
| chr1  | 99630 | 99717 | intron  | NPC |
| chr1  | 113860  | 113950  | intron  | NPC |
| chr1  | 128619  | 128757  | intron  | NPC |

</td><td>
  
| Region  | DHSCount  |
| ------------- | ------------- |
|  NPC  | 383039 |
| PC  | 1508556 |
| Total | 3591898 |

 </td></tr> </table> 
