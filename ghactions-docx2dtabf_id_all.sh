#!/bin/bash

#this script checks the changes of the last commit and if docx file was changed it transforms it. Only works in github actions env!

echo starting docx2tei transformation
 
inputDir="data/docx/band_001/"
teiOutputDir="data/tei/band_001/"
dtabfOutputDir="data/dtabf/band_001/"
dtabfIdOutputDir="data/dtabf_id/band_001/"

filesChanged=false;

cwd=$(pwd)

mkdir -p ${teiOutputDir}temp

for changed_file in $changes; do
  echo "Found changed file: ${changed_file}."
  if [[ "$changed_file" == *"$inputDir"* ]]; then
    #check if file is docx
    if [[ "$changed_file" == *".docx" ]]; then
      echo "Found changed docx: ${changed_file}"
      filesChanged=true;
      name=$(basename "$changed_file" .docx)
      echo $name
    fi

    if test -f "$outputDir$name.xml"; then
      echo "removing old xml file"
      rm "$outputDir$name.xml"
    fi

    if test -f "$changed_file"; then
      echo "Docx was changed/added. Starting transform"
      echo "Starting docx to tei transformation"
      ant -f src/docx2tei/docx/build-from.xml -DinputFile=../../../$changed_file -DoutputFile="${cwd}/${teiOutputDir}temp/$name.xml"
      java -cp src/docx2tei/saxon-he-10.jar net.sf.saxon.Transform -s:"${cwd}/${teiOutputDir}temp/$name.xml" -xsl:"${cwd}/src/docx2tei/docx2tei.xsl" -o:"${cwd}/${teiOutputDir}$name.xml"
  
      echo "Starting tei to dtabf transformation"
      java -cp src/tei2dtabf/xquery/saxon-he-10.jar net.sf.saxon.Query src/tei2dtabf/xquery/TeiToDtaBf.xquery -s:$teiOutputDir$name.xml -o:$dtabfOutputDir$name.xml
    fi
  fi
done

rm -r ${teiOutputDir}temp

if [ "$filesChanged" = true ]; then
  echo cleaning up files $dtabfOutputDir
  #loop over every file in docx folder
  for file in $dtabfOutputDir*; do
    name=$(basename "$file" .xml)
    #check if name isnt occuring in docx folder
    echo checking $file
    if ! test -f "$inputDir$name.docx"; then
    #check if file exists
      if test -f "$file"; then
        echo "removing $file"
        rm "$file"
      fi
    fi
  done
  echo transforming dtabf to dtabf_id
  bash dtabf2dtabf_id_all.sh
fi

echo transformation was successfull

echo cleaning up files $dtabfIdOutputDir
#loop over every file in docx folder
for file in $dtabfIdOutputDir*; do
  name=$(basename "$file" .xml)
  #check if name isnt occuring in docx folder
  echo checking $file
  if ! test -f "$inputDir$name.docx"; then
    #check if file exists
    echo "removing file: $file"
    if test -f "$file"; then
      echo "removing $file"
      rm "$file"
    fi
  fi
done

echo zipping dtabf_id data

cwd=$(pwd)

if  test -f "${cwd}/data/dtabf_id-band_001.zip"; 
then
    echo "removing zip letters"
    rm "${cwd}/data/dtabf_id-band_001.zip"
else 
    echo "no zip file of letters"    
fi

if  test -f "${cwd}/data/register.zip"; 
then
    echo "removing zip register"
    rm "${cwd}/data/register.zip"
else
    echo "no zip file of register"    
fi

if [ "$(ls -A ${cwd}/data/dtabf_id/band_001/)" ]; 
then
    echo "zip letters"
    cd ${cwd}/data/dtabf_id/band_001/
    zip -r ${cwd}/data/dtabf_id-band_001.zip *.xml
else
    echo "no letters to zip"
    exit
fi

if [ "$(ls -A ${cwd}/data/register/)" ]; then
    echo "zip register"
    cd ${cwd}/data/register/
    zip -r ${cwd}/data/register.zip *.xml
else
    echo "no register to zip"
    exit
fi

cd ${cwd}

echo zipping dtabf_id data was successfull