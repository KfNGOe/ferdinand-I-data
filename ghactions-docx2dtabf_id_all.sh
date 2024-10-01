#!/bin/bash

#this script checks the changes of the last commit and if docx file was changed it transforms it. Only works in github actions env!

echo starting docx2tei transformation
 
inputDir="data/docx/band_001/"
teiOutputDir="data/tei/band_001/"
dtabfOutputDir="data/dtabf/band_001/"
dtabfIdOutputDir="data/dtabf_id/band_001/"
inputDirJson="data/json/"

filesChanged=false;

cwd=$(pwd)

mkdir -p ${teiOutputDir}temp

if [ -z "$changes" ]
then
      echo "\$changes is empty"
else
      echo "\$changes is NOT empty"
      
      if [[ "$changes" == *"$inputDirJson"* ]]; 

      then
        echo "Found changed json: ${changes}"
        filesChanged=true;
        echo transforming dtabf to dtabf_id
        bash dtabf2dtabf_id_all.sh 
        
      else echo "no json changed"
           echo "checking docx files"    

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
                  
                  echo "common part"
                  ant -verbose -f src/docx2tei/docx/build-from.xml -DinputFile=../../../$changed_file -DoutputFile="${cwd}/${teiOutputDir}temp/$name.xml"
                  
                  echo "custom part"
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
      fi      
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

echo zipping data

cwd=$(pwd)

if  test -f "${cwd}/data/data.zip"; 
then
    echo "removing zip data"
    rm "${cwd}/data/data.zip"
else 
    echo "no zip file of data"    
fi

if [ "$(ls -A ${cwd}/data/)" ]; 
then
    echo "zip data"
    cd ${cwd}/data/
    zip -r ${cwd}/data/data.zip *
else
    echo "no data to zip"
    exit
fi

cd ${cwd}

echo zipping data was successfull