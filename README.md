# DHS_Repeat_Annotation
Annotating the DHS Masterlist with Repeated Regions


## Steps
1. Download RepeatMasker and DHS Masterlist Files
2. Map to DHS Masterlist and echo the overlap and mapped-element size
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


*Sample Rows and Columns*

| genoName  | genoStart | genoEnd  | strand | repName | repClass  | repFamily |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1  |	67108753  | 67109046  | + | L1P5  | LINE  | L1  |
| chr1  | 8388315 | 8388618 | - | AluY  | SINE  | Alu |
| chr1  | 25165803  | 25166380  | + | L1MB5 | LINE  | L1  |
| chr1  | 33554185  | 33554483  | - | AluSc | SINE  | Alu |
| chr1  | 41942894  | 41943205  | - | AluY  | SINE  | Alu |

## Download DHS Masterlist
* Go to [DHS Mastlerst](https://zenodo.org/record/3542126#.XffhGZNKgWp)

Download DHS_Index_and_Vocabulary_hg38_WM20190703.txt.gz

```
gunzip DHS_Index_and_Vocabulary_hg38_WM20190703.txt.gz
cut -f1-3 DHS_Index_and_Vocabulary_hg38_WM20190703.txt > DHS_Index.bed


# Map to DHS Masterlist and echo the overlap and mapped-element size

1. Gunzip repeats_ucsc.gzip
2. Remove Header
3. Exract only the columns above
4. Sort File
5. Remove classifications with question marks
6. Use bedmap to map and echo the overlap size and mapped-element size

```
module load bedops

gunzip repeats_ucsc.gzip

tail -n +2 repeats_ucsc \ 
| cut -f6-8,10-13 \
| sort-bed - \    
| grep -v LTR? | grep -v DNA? | grep -v RC? | grep -v SINE? \ 
| bedmap --echo --echo-map --echo-overlap-size --echo-map-size --skip-unmapped --ec DHS_Index.bed - \ 
> repeats_mapped_with_overlapPlusExtra.bed
```

**Multiple mapped elements will be seperated by a semicolon**

Example Output:

| chr | dhsStart | dhsEnd | genoName  | genoStart | genoEnd  | strand | repName | repClass  | repFamily | overlapSize | mapSize |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1 | 51868 | 52040 | chr1 | 51584 | 51880 | + | AluYj4 | SINE | Alu| 12 | 296 |
| chr1 | 66370 | 66482 | chr1 | 66157 | 66632 |+ |(AT)n | Simple_repeat | Simple_repeat | 112 | 475 |
| chr1 | 79100 | 79231| chr1 | 78890 | 79850 | + | L1PREC2 | LINE | L1 | 131| 960 |





# Choose element that has the largest overlap or the largest fraction of overlap, if there is a tie.

> Need: 
> repeats_mapped_with_overlapPlusExtra.bed

Run
```
choose_best_annotation.sh
```



Resulting bed file will include 7 unique elements under class: SINE, LINE, LTR, Simple_repeat, DNA, Low_Complexity, or Other (includes anything not already named)

| chr | dhsStart | dhsEnd | class | family |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| chr | 151868 | 52040 | SINE | Alu |
| chr1 | 66370 | 66482 | Simple_repeat | Simple_repeat |
| chr1 | 79100 | 79231 | LINE | L1 |
| chr1 | 79430 | 79497 | LINE | L1 |
| chr1 | 79580 | 79760 | LINE | L1 |
| chr1 | 87220 | 87295 | SINE | Alu |


Counts:

| class | DHSCount |
| ------------- | ------------- |
| DNA | 196686 |
| LINE | 605539 | 
| Low_complexity | 23210 |
| LTR | 451872 |
| Others | 20917 | 
| Simple_repeat | 118922 | 
| SINE | 513603 | 
| Total |  1930749 |


# Annotate Family Repeats

1. Extract SINE, LTR, DNA, and LINE annotated DHS's and place in separate bed files
2. Split Classes into Families

Notes on Subfamilies

* SINE -> Alu, MIR, and Others
* LTR -> ERVL-MaLR, ERV1, ERVL, Others
* DNA -> hAT-Charlie, TcMar-Tigger, Others
* LINE -> L1, L2, Others

> Need:
> dhs_annotated_7-repeats.bed

Run:
```
annotate_families.sh
```

Output Example

<table>
<tr><th>SINE.bed </th><th>SINE Family DHS Counts</th></tr>
<tr><td>
 

| chr | dhsStart | dhsEnd | Class | Family |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1 | 51868 | 52040 | SINE | Alu |
| chr1 | 87220 | 87295 | SINE | Alu |
| chr1 | 128619 | 128757 | SINE | Alu |
| chr1 | 284375 | 284489 | SINE | MIR |
| chr1 | 740730 | 740844 | SINE | Alu |

</td><td>

| Family  | DHSCount  |
| ------------- | ------------- |
| Alu | 256390 |
| MIR | 250203 |
| Others | 7010 |
| Total | 3591898 |

</td></tr> </table>
