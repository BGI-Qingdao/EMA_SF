CURR_DIR=`pwd`
mkdir -p $CURR_DIR/OUT_DIR
bash /../bin/EMA_SF -1 $CURR_DIR/chr8_400k.r1.fq.gz -2 $CURR_DIR/chr8_400k.r2.fq.gz -t 20 -r $CURR_DIR/../ref/chr8.fa -o $CURR_DIR/OUT_DIR -e $CURR_DIR/../tool/
