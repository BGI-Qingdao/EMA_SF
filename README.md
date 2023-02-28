# EMA_SF

Briefly Description
---

the **EMA** pipeline for **stLFR** sequencing data **fast** launch.

Denpendencies:
---

+ EMA version 0.6.2 (https://github.com/arshajii/ema.git)
+ samtools Version: 1.9 (using htslib 1.9)
+ sambamba Version 0.6.6 (conda install -c bioconda sambamba)
+ Parallel (https://doi.org/10.5281/zenodo.5233953)

How to use:
---
```
Usage:
        bash EMA_SF.sh -1 stLFR1.fq.gz -2 stLFR2.fq.gz -t Thread_Num -r Ref_fa -o Result_Dir -e Tool_PATH 
Option:
        -1 <The clean stLFR fq.1.fq.gz file> 
        -2 <The clean stLFR fq.2.fq.gz file> 
        -t <The number of thread> 
        -r <The reference sequences file: must be bwa index ref.fa and samtools faidx ref.fa> 
        -o <The output folder> 
        -e <The third-party tools should contain the ema, bwa, sambamba and parallel> 
        -h <help> 
```
