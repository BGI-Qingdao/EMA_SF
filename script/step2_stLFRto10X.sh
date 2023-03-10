#!/bin/bash

SHELL_PATH=`dirname $0`
source $SHELL_PATH/../config/profile
echo $SHELL_PATH/../config/profile

BQT=$BARCODE_FREQ_THRESHOLD

echo "Check input files ..."
date
#WL=`ls /node02/qiyanwei1/project2/reseq/ema_sf/config/4M-with-alts-february-2016.txt`
WL=$SHELL_PATH"/../config/Barcode-200M-Whitelist-2018.txt"
echo $WL
echo "10X whitelist in $WL"
if [[ ! -f $WL ]] ; then 
    echo "ERROR : no barcode white list found in $WL"
    echo "Exit ..."
    exit 1
fi

if  [[ $USE_FILTER == "yes" ]] ; then 
    if [[ ! -f $SPLIT.1.fq.gz.clean.gz || ! -f $SPLIT.1.fq.gz.clean.gz ]] ; then 
        echo "error : file $SPLIT.1.fq.gz.clean.gz or $SPLIT.2.fq.gz.clean.gz is not exsist !!! exit ..."
        exit 1;
    fi
    if [[ ! -f $CLEAN_BARCODE_FREQ ]] ; then 
        echo "ERROR : file $CLEAN_BARCODE_FREQ is not exsist !!! Exit ..."
        exit 1;
    fi
else
    if [[ ! -f $SPLIT.1.fq.gz || ! -f $SPLIT.1.fq.gz ]] ; then 
        echo "error : file $SPLIT.1.fq.gz or $SPLIT.2.fq.gz is not exsist !!! exit ..."
        exit 1;
    fi
    if [[ ! -f $BARCODE_FREQ ]] ; then 
        echo "ERROR : file $BARCODE_FREQ is not exsist !!! Exit ..."
        exit 1;
    fi
fi

SCRIPT_PATH=$SHELL_PATH"/../"

if [[ $USE_FILTER == "yes" ]] ; then 
    date
    tag=`date +_%m_%d_%H_%M_%S`
    echo "Generate $MERGE ..."
    $SCRIPT_PATH/script/merge_barcodes.pl $CLEAN_BARCODE_FREQ  $WL $MERGE $BQT  1> merge_barcode_"$tag".log  2>merge_barcode_"$tag".err || exit 1
    echo "Fake 10X data . this will take a long time ... "
    date
    tag=`date +_%m_%d_%H_%M_%S`
    $SCRIPT_PATH/script/fake_10x.pl  $SPLIT.1.fq.gz.clean.gz $SPLIT.2.fq.gz.clean.gz $MERGE >fake_10X_"$tag".log 2>fake_10X_"$tag".err || exit 1
else  
    date
    tag=`date +_%m_%d_%H_%M_%S`
    echo "Generate $MERGE ..."
    $SCRIPT_PATH/script/merge_barcodes.pl $BARCODE_FREQ  $WL $MERGE $BQT   1> merge_barcode_"$tag".log  2>merge_barcode_"$tag".err || exit 1
    echo "Fake 10X data . this will take a long time ... "
    date
    tag=`date +_%m_%d_%H_%M_%S`
    $SCRIPT_PATH/bin/fake_10x.pl  $SPLIT.1.fq.gz $SPLIT.2.fq.gz $MERGE  >fake_10X_"$tag".log 2>fake_10X_"$tag".err || exit 1
fi
echo "done step 2 ..."
date


