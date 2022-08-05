#!/bin/bash

#this script transforms docx to dtabf_id.

echo starting docx2dtabf_id transformation
 
inputDir="data/docx/band_001/"
teiOutputDir="data/tei/band_001/"
dtabfOutputDir="data/dtabf/band_001/"

rm -R $teiOutputDir
rm -R $dtabfOutputDir

cwd=$(pwd)

for filename in $inputDir*.docx; do
  name=$(basename "$filename" .docx)
  echo $name
  
  echo "transforming docx to tei"
  ant -f ./src/docx2tei/docx/build-from.xml -DinputFile=../../../$filename -DoutputFile="${cwd}/${teiOutputDir}tempIn/$filename.xml"
  java -cp src/docx2tei/saxon-he-10.jar net.sf.saxon.Transform -s:"${cwd}/${teiOutputDir}tempIn/$filename.xml" -xsl:"${cwd}/src/docx2tei/docx2tei.xsl" -o:"${cwd}/${teiOutputDir}$name.xml"

  echo "transforming tei to dtabf"
  java -cp src/tei2dtabf/xquery/saxon-he-10.jar net.sf.saxon.Query src/tei2dtabf/xquery/TeiToDtaBf.xquery -s:$teiOutputDir$name.xml -o:$dtabfOutputDir$name.xml
done

echo transforming dtabf to dtabf_id
. dtabf2dtabf_id_all.sh

echo transformation was successfull

#cd data/dtabf_id/data/dtabf_id/band_001/
#zip -r band_001.zip ./*.xml
#mv band_001.zip ../../../../dtabf_id-band_001.zip
#cd ../../../../../
#echo zipping dtabf_id data was successfull
