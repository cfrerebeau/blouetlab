#!/bin/bash

#Script to extract all the columns
while getopts i:g:o: option
do
 case "${option}"
 in
 i) INPUT=${OPTARG};;
 g) GENE=${OPTARG};;
 o) OUTPUT=${OPTARG};;
 esac
done
DIR=.tmp
mkdir -p $DIR

#Extract the first column of the data file (if not already extracted)
#if [ ! $DIR/first_column.txt ]; then
 awk '{print $1}' $INPUT > $DIR/first_column.txt
#fi
#look in that first column what is the line with the gene
LINE_NUMBER=$(grep -ni $GENE $DIR/first_column.txt | cut -f1 -d:)

#extrac the line with the gene
sed -n $(echo $LINE_NUMBER)p $INPUT > $DIR/line_of_$GENE.txt

#name of file
FILE_GREATER_THAN_5=$DIR/field_of_${GENE}_greather_than_5.awk

#adding first column (always to be extracted)
echo -ne "BEGIN{}\n{print \$1\"\\t\"" >  $FILE_GREATER_THAN_5
#adding all the index of the column greater than 5
gawk '{ for (i = 2; i <= NF; ++i) { if($(i)>=1) printf "$%s\"\\t\"\t",i } }' $DIR/line_of_$GENE.txt >> $FILE_GREATER_THAN_5
echo -ne "}\nEND{}" >>  $FILE_GREATER_THAN_5

gawk -f $FILE_GREATER_THAN_5 $INPUT > $OUTPUT
