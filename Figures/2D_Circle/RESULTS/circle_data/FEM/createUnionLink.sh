#!/bin/bash
cat fileList | while read line;
do
dir=$( echo $line | sed 's/\/dat\//\//;s/$/\/matlab\/conv.M1.union.mat/');
echo $line $dir;
done
