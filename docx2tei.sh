#!/bin/bash

#this script loops over every .docx file in inputDir and transforms it with ant to an tei in output dir

echo starting docx2tei transformation
 
inputDir="letters/docx/band_001/"
outputDir="letters/tei/band_001/"

rm -r $outputDir

for filename in $inputDir*.docx; do
   echo converting $filename
   name=$(basename "$filename" .docx)
   echo $name
   ant -f ./src/docx2tei/docx/build-from.xml -DinputFile="../../../$filename" -DoutputFile="../../../$outputDir$name.xml"
done

echo transformation was successfull
