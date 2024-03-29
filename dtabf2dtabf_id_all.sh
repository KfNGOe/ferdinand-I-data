#!/bin/bash
echo starting dtabf2dtabf_id transformation
 
inputDir="data/dtabf/band_001/"
outputDir="data/dtabf_id/band_001/"
regDir="data/register/"
regTmpDir="data/register/tmp/"

rm -r -f $outputDir
rm -r -f $regDir

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
mkdir $regDir
mkdir $regTmpDir

echo "$configFile" > "$inputDir"collection.xml

echo "generating register"
java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_register_make_place.xsl -o:data/register/register_place.xml

java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_register_make_person.xsl -o:data/register/register_person.xml

java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_register_make_index.xsl -o:data/register/register_index.xml

echo "copy id's"
java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_letters_copy_id.xsl -o:data/dtabf_id/out.xml

rm -r $regTmpDir
echo "replace single quotes with apostrophe"
find ./data/json/register_place_writings.json -type f -exec sed -i "s/'/’/g" {} \;
echo "add backslash to single quotes"
find ./data/json/register_place_writings.json -type f -exec sed -i "s/'/\\\\\'/g" {} \;

echo transformation was successfull

