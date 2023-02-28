outDIR=$1
cd $outDIR
SOAPnuke=`pwd`"/../tool/SOAPnuke2.1.5/SOAPnuke"
$SOAPnuke filter -c filter_config -f AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -r GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA -J -l 10 -q 0.1 -n 0.05  -f CTGTCTCTTATACACATCTTAGGAAGACAAGCACTGACGACATGA -r TCTGCTGAGTCGAGAACGTCTCTGTGAGCCAAGGAGTTGCTCTGG -T 2 -1 split_reads.1.fq.gz -2 split_reads.2.fq.gz -C split_reads.1.fq.gz.clean.gz -D split_reads.2.fq.gz.clean.gz -o $outDIR


