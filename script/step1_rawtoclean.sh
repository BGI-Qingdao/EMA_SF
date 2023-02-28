outDIR=$1
cd $outDIR
/dellfsqd2/ST_OCEAN/USER/sunshuai/software/reads/SOAPnuke-SOAPnuke2.1.5/SOAPnuke filter -c filter_config -f AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC -r GATCGGAAGAGCGTCGTGTAGGGAAAGAGTGTA -J -l 10 -q 0.1 -n 0.05  -f CTGTCTCTTATACACATCTTAGGAAGACAAGCACTGACGACATGA -r TCTGCTGAGTCGAGAACGTCTCTGTGAGCCAAGGAGTTGCTCTGG -T 2 -1 split_reads.1.fq.gz -2 split_reads.2.fq.gz -C split_reads.1.fq.gz.clean.gz -D split_reads.2.fq.gz.clean.gz -o $outDIR


