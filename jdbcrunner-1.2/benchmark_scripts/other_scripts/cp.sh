#!/bin/bash


#for file in 12-18/*/*/*/bkp_result.txt
for file in old_11_result/*/*/*/BKP_RESULT.txt
do
{
#echo "$file"

f=${file#*/}
cp $file Result/benchmark/$f
}
done
