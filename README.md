# DHS_Repeat_Annotation
Annotating the DHS Masterlist with Repeated Regions


## Steps
1. Download RepeatMasker File
2. Map to DHS Masterlist and echo the overlap and mapped-element size
3. Choose element that has the largest overlap or the largest fraction of overlap, if there is a tie
4. Rename Annotation to SINE, LINE, LTR, Simple_repeat, DNA, or Other (includes anything not already named)


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
4. Use Bedmap to map and echo the overlap size and mapped-element size

```
module load bedops
 
tail -n +2 $repeats \  
| sort-bed - \    
| grep -v LTR? | grep -v DNA? | grep -v RC? | grep -v SINE? \ 
| bedmap --echo --echo-map --echo-overlap-size --echo-map-size --skip-unmapped --ec $dhs - \ 
> repeats_mapped_with_overlapPlusExtra.bed
```
Output:

| chr | dhsStart | dhsEnd | genoName  | genoStart | genoEnd  | strand | repName | repClass  | repFamily | overlapSize | mapSize |
| ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- | ------------- |
| chr1 | 51868 | 52040 | chr1 | 51584 | 51880 | + | AluYj4 | SINE | Alu| 12 | 296 |
| chr1 | 66370 | 66482 | chr1 | 66157 | 66632 |+ |(AT)n | Simple_repeat | Simple_repeat | 112 | 475 |
| chr1 | 79100 | 79231| chr1 | 78890 | 79850 | + | L1PREC2 | LINE | L1 | 131| 960 |

**Muliple overlaps will be seperated by a semicolon**

### Choose element that has the largest overlap or the largest fraction of overlap, if there is a tie

> Need: repeats_mapped_with_overlapPlusExtra.bed

Run
```
choose_best_annotation.sh
```

### Rename Annotation to SINE, LINE, LTR, Simple_repeat, DNA, or Other (includes anything not already named)
