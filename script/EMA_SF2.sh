#!/bin/bash


helpdoc(){
        cat<<EOF
Usage:
        Input file list
Option:
        -1 <The clean stLFR fq.1.fq.gz file>
        -2 <The clean stLFR fq.2.fq.gz file>
	-t <The number of thread>
	-r <The reference sequences file>
        -o <The output folder>
	-h <help>
EOF
}


while getopts ":1:2:t:r:o:h" opt
do
        case $opt in
                1) stLFR1=$OPTARG;;
                2) stLFR2=$OPTARG;;
		t) Thread=$OPTARG;;
                r) refSeq=$OPTARG;;
                o) outDIR=$OPTARG;;
                h|help) helpdoc exit 1 ;;
                ?) echo "$OPTARG Unknown parameter"
                exit 1;;
        esac
done

if [ $# = 0 ]
then
    helpdoc
    exit 1
fi

PIPESOFT_DIR=$(dirname "$0")

#export PATH='/zfsqd1/ST_OCEAN/USRS/qiyanwei/software/bin:$PATH'
echo $outDIR
cd $outDIR

mkdir output_dir


## step1 stLFR to 10X 
ln -s $stLFR1 split_reads.1.fq.gz.clean.gz
ln -s $stLFR2 split_reads.2.fq.gz.clean.gz

echo CovertTo10X Starting at: `date`
echo gzip -dc split_reads.1.fq.gz.clean.gz |  awk -F '#|/' '{if(NR%4==1&&NF>1)t[$2]+=1}END{for(x in t ) printf("%s\t%s\n",x,t[x]);}'  > clean_barcode_freq.txt
echo sh $PIPESOFT_DIR/step2_stLFRto10X.sh 
echo awk '{print $2}' merge.txt >  whitelist.txt 
echo Ending at: `date`

## step2 Count
echo Count Starting at:`date`
echo parallel -j$Thread --bar 'paste <(pigz -c -d {} | paste - - - -) <(pigz -c -d {= s:-R1_:-R2_: =} | paste - - - -) | tr "\t" "\n" |ema count -w whitelist.txt -o {/.} 2>{/.}.log' ::: *-R1_*.gz
echo Count End at:`date`

## Step3 Preprocessing
echo Preprocessing Starting at: `date`
echo "paste <(pigz -c -d *-R1_*.gz | paste - - - -) <(pigz -c -d *-R2_*.gz | paste - - - -) | tr "\t" "\n" |ema preproc -w whitelist.txt -n 250 -t "$Thread" -o ./output_dir *.ema-ncnt 2>&1 | tee preproc.log"
echo Preprocessing Ending at: `date`

## Step4 Mapping
echo Mapping starting at: `date`

echo "parallel --bar -j$Thread \"ema align -t 2 -d -r $refSeq -s {} |samtools sort -@ 4 -O bam -l 0 -m 4G -o {}.bam -\" ::: ./output_dir/ema-bin-???"
echo Mapping ending at: `date`

echo "bwa mem -p -t $Thread -M -R "@RG\tID:rg1\tSM:sample1" $refSeq output_dir/ema-nobc | samtools sort -@ 4 -O bam -l 0 -m 4G -o output_dir/ema-nobc.bam"

## Step5 Postprocessing
echo Postprocessing starting at: `date`
echo "sambamba markdup -t $Thread -p -l 0 output_dir/ema-nobc.bam output_dir/ema-nobc-dupsmarked.bam"
echo "mv output_dir/ema-nobc.bam ./"

echo "sambamba merge -t $Thread -p ema_final.bam output_dir/*.bam"

echo Postprocessing ending at: `date`
