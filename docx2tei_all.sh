#!/bin/bash

#this script loops over every .docx file in inputDir and transforms it with ant to an tei in output dir

echo starting docx2tei transformation
 
inputDir="data/docx/band_001/"
outputDir="data/tei/band_001/"

cwd=$(pwd)

rm -r $outputDir

for filename in $inputDir*.docx; do
   echo converting $filename
   name=$(basename "$filename" .docx)
   echo $name
  ant -f ./src/docx2tei/docx/build-from.xml -DinputFile=../../../$filename -DoutputFile="${cwd}/${outputDir}tempIn/$filename.xml"
  java -cp src/docx2tei/saxon-he-10.jar net.sf.saxon.Transform -s:"${cwd}/${outputDir}tempIn/$filename.xml" -xsl:"${cwd}/src/docx2tei/docx2tei.xsl" -o:"${cwd}/${outputDir}$name.xml"
  # . docx2tei.sh $filename $outputDir
done

echo transformation was successfull
