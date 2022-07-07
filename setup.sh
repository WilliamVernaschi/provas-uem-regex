#!/bin/bash

# Sai do programa se qualquer comando falhar.
set -e

# Seleciona pasta de download padrão
download_loc="$(pwd)"

PDFTOTEXT_LOC=`which pdftotext`
if [ -z "$PDFTOTEXT_LOC" ] || [ ! -f "$PDFTOTEXT_LOC" ] || [ ! -x "$PDFTOTEXT_LOC" ]
then
  echo "A utilidade pdftotext precisa estar instalada, ela está presente no pacote poppler ou poppler-utils, dependendo da sua distribuição."
  exit 1
fi

if [ ! -d "${download_loc}/uem_provas" ]; then
  mkdir "$download_loc/uem_provas"
elif [ ! -f "${download_loc}/uem_provas/.downloadnotcomplete" ]; then
  read -p "já existe ${download_loc}/uem_provas, deseja apagar
os conteúdos da pasta e baixar novamente? [sy/n] " confirm
  [ "$confirm" == "s" -o  "$confirm" == "S" -o  "$confirm" == "y" -o "$confirm" == "Y" ] &&
  rm -r "$download_loc/uem_provas/" && mkdir $download_loc/uem_provas || exit 1
fi

cd "$download_loc/uem_provas"
echo "$download_loc/uem_provas" > .localprovas

touch .downloadnotcomplete
# baixando as provas
wget --quiet --show-progress --no-parent --recursive --no-clobber --tries=10 --timeout=30\
 --accept '*.html,*.pdf'\
 --reject '*g2*,*g3*,*g4*,*listao*,*[Ii]ndigenas*,*[Rr]esultado*,*[Cc]oncorrencia*,
 *[Mm]anual*,*[Ee]dital*,*[Ii]ndex*,*[Cc]otistas*,[Ee]statisticas,[Aa]provados,CT*.pdf,LG*.pdf,AP*.pdf,ES*.pdf'\
 https://www.cvu.uem.br/provas/ https://www.vestibular.uem.br/vestibulares_anteriores.html
rm .downloadnotcomplete

# Removendo alguns arquivos indesejados
find . | grep -Pi '^(((?!gabarito(p?[1-4]|_prova_objetiva).html).)*\.html|.*resultado.*|.*indigenas.*)$' |\
  xargs rm -rf

if [ -d 'www.vestibular.uem.br' -a -d 'www.cvu.uem.br' ]
then
  mv */* . && mv provas/* .
  rmdir www* provas
fi
echo "Provas baixadas"

for prova in $(find -name "*.pdf")
do
  echo "Transformando $prova em .txt..."
  pdftotext -q "$prova"
done

# Formatando o nome das pastas.
for ano in $(find -type d)
do
  if [ "${ano:2:3}" == 'pas' ]; then
    mv "$ano" "20${ano:5:2}-PAS"
  elif [ "${ano:2:3}" == 'ead' ]; then
    mv "$ano" "20${ano:5:2}-EAD"
  elif [ "${ano:0:3}" == 'ind' ]; then
    mv "$ano" "20${ano:5:2}-IND"
  elif [ "${ano:2:2}" == 'in' ]; then
    mv "$ano" "20${ano:4:2}-I"
 elif [ "${ano:2:2}" == 've' ]; then
    mv "$ano" "20${ano:4:2}-V"
  fi
done
