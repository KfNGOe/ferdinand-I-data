#!/bin/bash

#example: . dtabf2dtabf_id.sh data/dtabf/band_001/A001.xml data/dtabf_id/band_001/

echo starting dtabf2dtabf_id transformation
 
#read input flags
inputFile=$1
filename=$(basename "$inputFile" .xml)
outputFolder=$2

cwd=$(pwd)

echo generating register
java -jar src/dtabf2dtabf_id/saxon-he-10.jar -s:$inputFile -xsl:src/dtabf2dtabf_id/test_register_make_place.xsl -o:data/register/register_place.xml

java -jar src/dtabf2dtabf_id/saxon-he-10.jar -s:$inputFile -xsl:src/dtabf2dtabf_id/test_register_make_person.xsl -o:data/register/register_person.xml

java -jar src/dtabf2dtabf_id/saxon-he-10.jar -s:$inputFile -xsl:src/dtabf2dtabf_id/test_register_make_index.xsl -o:data/register/register_index.xml

echo copy id's
java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:$inputFile -xsl:src/dtabf2dtabf_id/test_letters_copy_id.xsl -o:"${cwd}/$outputFolder/out.xml"

#java -jar src/tei2dtabf/xquery/saxon-he-10.jar -s:data/dtabf_id/band_001/collection.xml -xsl:src/dtabf2dtabf_id/test_register_make_place.xsl -o:out.xml

echo transformation was successfull
