#!/bin/bash

#this script transforms docx to dtabf_id.

echo starting docx2dtabf_id transformation
 
teiOutputDir="data/tei/band_001/"
dtabfOutputDir="data/dtabf/band_001/"

rm -r $dtabfOutputDir

for filename in $teiOutputDir*.xml; do
    name=$(basename "$filename" .xml)
    echo $name
      java -cp src/tei2dtabf/xquery/saxon-he-10.jar net.sf.saxon.Query src/tei2dtabf/xquery/TeiToDtaBf-v2.xquery -s:$teiOutputDir$name.xml -o:$dtabfOutputDir$name.xml
done

echo transdorming dtabf to dtabf_id

 
inputDir=$dtabfOutputDir
outputDir="./data/dtabf_id/band_001/"

rm -r -f $outputDir
#rm -r -f "./data/dtabf_id/band_001/"

echo generating Config file

configFile='<collection stable="true">'

for filename in $inputDir*.xml; do
   name=$(basename "$filename" .xml)
   start='<doc href="../../dtabf/band_001/'
   end='.xml"/>'
   line="$start$name$end"
   configFile+="$line"
done

configFile+="</collection>"
mkdir $outputDir
echo "$configFile" > "$outputDir"collection.xml

echo generating register
java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf_id/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_register_make_place.xsl -o:data/register/register_place.xml
java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf_id/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_register_make_person.xsl -o:data/register/register_person.xml
java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf_id/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_register_make_index.xsl -o:data/register/register_index.xml

java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf_id/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_letters_copy_id.xsl -o:data/dtabf_id/band_001/out.xml

#java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf_id/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_register_make_place.xsl -o:out.xml

echo transformation was successfull


echo transformation was successfull
