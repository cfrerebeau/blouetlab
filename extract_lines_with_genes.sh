#!/bin/bash
#Extract the line of the umicount annotated formated file for each genes
#listed in the Gene file.
#Script to extract all the columns
while getopts i:g:o: option
do
  case "${option}"
      in
    i) INPUT=${OPTARG} ;;
    g) GENES=${OPTARG} ;;
    o) OUTPUT=${OPTARG} ;;
  esac
done

DIR=.tmp
mkdir -p $DIR
echo "Error log for file $INPUT" > $DIR/${INPUT}_error.log

#Extract the first column of the data file (if not already extracted)
#if [ ! $DIR/first_column.txt ]; then
awk '{print $1}' $INPUT > $DIR/${INPUT}_first_column
head -n 1 $INPUT > $OUTPUT

 while IFS=, read -r GENE; do
   echo "extracting Gene: $GENE"
   #Options n to display line number, option w to match whole word only
   LINE_NUMBER=$(grep -nw $GENE $DIR/${INPUT}_first_column| cut -f1 -d:)
   if [ $LINE_NUMBER -gt 0 ]
   then
     sed -n $(echo $LINE_NUMBER)P $INPUT >> $OUTPUT
   else
     echo "Warning: $GENE not found" >> $DIR/${INPUT}_error.log
   fi
 done < "$GENES"
