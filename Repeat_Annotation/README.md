# DHS_Repeat_Annotation
Annotating the DHS Masterlist with Repeated Regions

## Steps
1. Download RepeatMasker and DHS Masterlist Files
2. Map RepeatMasker to DHS Masterlist and echo the overlap and mapped-element size
3. Choose element that has the largest overlap or the largest fraction of overlap, if there is a tie
4. Rename Class Annotation to SINE, LINE, LTR, Simple_repeat, DNA, or Other (includes anything not already named)
5. Annotate DHS's based on Family Repeats


## Download RepeatMasker File
* Go to [UCSC Genome Browser Tables](http://genome.ucsc.edu/cgi-bin/hgTables)
```
Input 
clade: Mammal
genome: Human
assembly: Dec. 2013 (GRCh38/hg38)
group: Repeats
track: RepeatMasker
table: rmsk
region: genome
output format: all fields from selected table
output file: repeats_ucsc
file type returned: gzip compressed

```

Download repeats_ucsc.gz

## Download DHS Masterlist
* Go to [DHS Masterlist](https://zenodo.org/record/3542126#.XffhGZNKgWp)

Download DHS_Index_and_Vocabulary_hg38_WM20190703.txt.gz

## Complete the rest of the annotation with Repeat-Annotation.sh.ipynb 


#### Written description of steps outlined in Repeat-Annotation.sh.ipynb
#### Map to DHS Masterlist and echo the overlap and mapped-element size

1. Gunzip repeats_ucsc.gzip
2. Remove Header
3. Exract only the columns above
4. Sort File
5. Remove classifications with question marks
6. Use bedmap to map and echo the overlap size and mapped-element size

*Make sure to have bedops available to your current working directory*

#### Choose element that has the largest overlap or the largest fraction of overlap, if there is a tie.

Resulting bed file (dhs_annotated_7-classRepeats.bed) will include 7 unique elements under class: SINE, LINE, LTR, Simple_repeat, DNA, Low_Complexity, or Other (includes anything not already named)

#### Annotate and Clean-up Family Repeats

1. Extract SINE, LTR, DNA, and LINE annotated DHS's and place in separate bed files
2. Split Classes into Families

Notes on Subfamilies

* SINE -> Alu, MIR, and Others
* LTR -> ERVL-MaLR, ERV1, ERVL, Others
* DNA -> hAT-Charlie, TcMar-Tigger, Others
* LINE -> L1, L2, Others

## Results

Final directory will have 5 files and one "extra_files" subdirectory. DNA.bed, LINE.bed, LTR.bed, and SINE.bed are subsets of dhs_annotated_7-classRepeats.bed updated with the subfamilies listed above. The "extra_files" directory will include the initial downloaded files and important temporary files that lead to these final files. 

