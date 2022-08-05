#!/bin/bash

#this script takes an docx file as input and transforms it to tei / not used anymore sinde there is an more efficient solution with xsl apply modes

#example: . docx2tei.sh data/docx/band_001/A001.docx data/tei/test_tmp/

#read input flags
inputFile=$1
filename=$(basename "$inputFile" .docx)
outputFolder=$2

#xsl stylesheets
declare -a stylesheets=(
"docx2tei/custom/01.commentToRs.xsl"
"docx2tei/custom/02.rsToRef.xsl"
"docx2tei/custom/03.insertSeparationAnchor.xsl"
"docx2tei/custom/04.shiftSeparationAnchor.xsl"
"docx2tei/custom/05.separationAnchorToDiv.xsl"
"docx2tei/custom/06.addMissingRendKommentarInKommentar.xsl"
"docx2tei/custom/06.deleteEmptyDiv.xsl"
"docx2tei/custom/07.renameDivType.xsl"
"docx2tei/custom/08.addNToPInDiv.xsl"
"docx2tei/custom/09.removeN.xsl"
"docx2tei/custom/10.addMetadata.xsl"
)

cwd=$(pwd)

mkdir -p ${outputFolder}tempIn
mkdir -p ${outputFolder}tempOut

ant -f ./src/docx2tei/docx/build-from.xml -DinputFile=../../../$inputFile -DoutputFile="${cwd}/${outputFolder}tempIn/$filename.xml"

for i in "${stylesheets[@]}"
do
   echo applying $i
   java -cp src/docx2tei/saxon-he-10.jar net.sf.saxon.Transform -s:"${cwd}/${outputFolder}tempIn/$filename.xml" -xsl:"${cwd}/src/$i" -o:"${cwd}/${outputFolder}tempOut/$filename.xml"
  iName=$(basename "$i" .xsl)
   cp ${cwd}/${outputFolder}tempOut/$filename.xml ${cwd}/${outputFolder}$iName$filename.xml
   mv "${cwd}/${outputFolder}tempOut/$filename.xml" "${cwd}/${outputFolder}tempIn/$filename.xml"
done

mv "${cwd}/${outputFolder}tempIn/$filename.xml" "${cwd}/${outputFolder}$filename.xml"

#remove temp folder
rm -r ${outputFolder}tempIn
rm -r ${outputFolder}tempOut



cd $cwd

