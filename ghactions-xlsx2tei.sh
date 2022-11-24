#!/bin/bash

#this script converts xlsx mapping names to tei

inputDir="data/xlsx/"
teiOutputDir="data/tei/"

cwd=$(pwd)
echo $cwd
echo $inputDir

nfiles=$(ls $cwd/$inputDir/*.xlsx | wc -l)
if [ $nfiles = 1 ]; then
    echo "only one file exists"
		
	name=$(basename "$(ls $cwd/$inputDir/*.xlsx)" .xlsx)
		
	echo $name	
	
	echo "Starting xlsx to tei transformation"
	
	ant -f src/xlsx2tei/build-from.xml -DinputFile=../../$inputDir/$name.xlsx -DoutputFile=../../$teiOutputDir/$name.xml      
	
	echo "transformation was successfull"

else
    echo "$nfiles exist"
fi