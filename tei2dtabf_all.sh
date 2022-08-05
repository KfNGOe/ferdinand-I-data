#!/bin/bash

echo starting tei2dtabf transformation
 
inputDir="data/tei/band_001/"
outputDir="data/dtabf/band_001/"

rm -r -f $outputDir

for filename in $inputDir*.xml; do
   echo converting $filename
    name=$(basename "$filename" .xml)
   echo $name
   sudo java -cp src/tei2dtabf/xquery/saxon-he-10.jar net.sf.saxon.Query src/tei2dtabf/xquery/TeiToDtaBf.xquery -s:$inputDir$name.xml -o:$outputDir$name.xml
done

echo transformation was successfull
