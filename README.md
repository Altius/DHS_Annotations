# DHS_Repeat_Annotation
Annotating the DHS Masterlist with Repeated Regions


## Steps
1. Download RepeatMasker File
2. Map to DHS Masterlist and echo the overlap and mapped-element size
3. Choose element that has the largest overlap or the largest fraction of overlap, if there is a tie
4. Rename Class Annotation to SINE, LINE, LTR, Simple_repeat, DNA, or Other (includes anything not already named)
5. Annotate DHS's based on Family Repeats


### Download RepeatMasker File
| genoName  | genoStart | genoEnd  | strand | repName | repClass  | repFamily |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1  |	67108753  | 67109046  | + | L1P5  | LINE  | L1  |
| chr1  | 8388315 | 8388618 | - | AluY  | SINE  | Alu |
| chr1  | 25165803  | 25166380  | + | L1MB5 | LINE  | L1  |
| chr1  | 33554185  | 33554483  | - | AluSc | SINE  | Alu |
| chr1  | 41942894  | 41943205  | - | AluY  | SINE  | Alu |


### Map to DHS Masterlist and echo the overlap and mapped-element size

1. Remove Header
2. Sort Repeat File
3. Remove classifications with question marks
4. Use bedmap to map and echo the overlap size and mapped-element size

```
module load bedops
 
tail -n +2 $repeats \  
| sort-bed - \    
| grep -v LTR? | grep -v DNA? | grep -v RC? | grep -v SINE? \ 
| bedmap --echo --echo-map --echo-overlap-size --echo-map-size --skip-unmapped --ec $dhs - \ 
> repeats_mapped_with_overlapPlusExtra.bed
```

**Multiple mapped elements will be seperated by a semicolon**

Example Output:

| chr | dhsStart | dhsEnd | genoName  | genoStart | genoEnd  | strand | repName | repClass  | repFamily | overlapSize | mapSize |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1 | 51868 | 52040 | chr1 | 51584 | 51880 | + | AluYj4 | SINE | Alu| 12 | 296 |
| chr1 | 66370 | 66482 | chr1 | 66157 | 66632 |+ |(AT)n | Simple_repeat | Simple_repeat | 112 | 475 |
| chr1 | 79100 | 79231| chr1 | 78890 | 79850 | + | L1PREC2 | LINE | L1 | 131| 960 |





### Choose element that has the largest overlap or the largest fraction of overlap, if there is a tie.

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


### Annotate Family Repeats

1. Split dhs_annotated_7-repeats.bed file into 4 bed files (SINE, LINE, LTR, DNA)
2. Split Classes into subfamilies

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

</td></tr> </table>
