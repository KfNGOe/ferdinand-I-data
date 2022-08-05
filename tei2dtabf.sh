#!/bin/bash

#example: . tei2dtabf.sh data/tei/band_001/A001.xml data/dtabf/band_001/

echo starting tei2dtabf transformation
 
#read input flags
inputFile=$1
filename=$(basename "$inputFile" .xml)
outputFolder=$2

cwd=$(pwd)

sudo java -cp src/tei2dtabf/xquery/saxon-he-10.jar net.sf.saxon.Query src/tei2dtabf/xquery/TeiToDtaBf-v2.xquery -s:$inputFile -o:"${cwd}/$outputFolder/$filename.xml"

#ant -f ./src/docx2tei/docx/build-from.xml -DinputFile=../../../$inputFile -DoutputFile="${cwd}/${outputFolder}tempIn/$filename.xml"

echo transformation was successfull
