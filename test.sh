
inputDir="data/docx/band_001/"
teiOutputDir="data/tei/band_001/"
dtabfOutputDir="data/dtabf/band_001/"
dtabfIdOutputDir="data/dtabf_id/band_001/"

filesChanged=false;

cwd=$(pwd)

mkdir -p ${teiOutputDir}temp

rm -r ${teiOutputDir}temp