#!/bin/bash
#add the missing field (first column, first line) necessary to use awk properly
INPUT=$1
OUTPUT=$2
echo -ne 'Genes\t' > $OUTPUT
cat $INPUT >> $OUTPUT
