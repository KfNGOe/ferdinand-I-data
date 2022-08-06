#!/bin/bash

#this script checks the changes of the last commit and if docx file was changed it transforms it. Only works in github actions env!

echo starting docx2tei transformation
 
inputDir="data/docx/band_001/"
outputDir="data/tei/band_001/"

for changed_file in $changes; do
  echo "Found changed file: ${changed_file}."
  if [[ "$changed_file" == *"$inputDir"* ]]; then
    echo "Found changed docx: ${changed_file}"
    name=$(basename "$changed_file" .docx)
    echo $name

    if test -f "$outputDir$name.xml"; then
      echo "removing old xml file"
      rm "$outputDir$name.xml"
    fi

    if test -f "$changed_file"; then
      echo "Docx was changed/added. Starting transform"
      ant -f ./src/docx2tei/docx/build-from.xml -DinputFile=../../../$filename -DoutputFile="${cwd}/${outputDir}tempIn/$filename.xml"
  java -cp src/docx2tei/saxon-he-10.jar net.sf.saxon.Transform -s:"${cwd}/${outputDir}tempIn/$filename.xml" -xsl:"${cwd}/src/docx2tei/docx2tei.xsl" -o:"${cwd}/${outputDir}$name.xml"
     # . docx2tei.sh $changed_file $outputDir
    fi
  fi
done

echo transformation was successfull
