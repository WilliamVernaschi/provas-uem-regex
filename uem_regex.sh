#!/bin/bash

# remove os arquivos que restaram de uma busca interrompida
[ -f .tempgabarito ] && rm .tempgabarito
[ -f .tempanswers ] && rm .tempanswers
[ -f .completeout ] && rm .completeout

# busca as correspondências nas provas e a pastas onde estão os gabaritos dessas, e então
# guarda nos arquivos temporários .tempanswers e .tempgabarito
ls -d ~/uem_provas/* | sort -n | xargs -d '\n' egrep --color=always\
  --group-separator=----------------------------- -ri -A 1 -B 1 --include\
  "*.txt" "$1" | uniq | sed 's@/home/@file:/home/@g' | sed 's/\.txt/\.pdf /g'\
  | tee .tempanswers | egrep --color=never -o  '/home[^ ]*/' | uniq | sed s@file:@@g > .tempgabarito


[ ! -s .tempanswers ] && echo "Nenhuma correspondência encontrada." && return 0

touch .completeout

# junta os dois arquivos temporários em um único
while read -r a; do
  if [ "$a" == '[36m[K-----------------------------[m[K' ]
  then
    if [[ $(echo "$prev_a" | egrep --color=never -o  '/home[^ ]*/') != "$b" ]]
    then
      read -r b <&3
    fi
    echo -e "Gabarito:\n$b\n$a" >> .completeout
  else
    echo -e "$a" >> .completeout
  fi
  prev_a="$a"
 done < .tempanswers 3<.tempgabarito
echo -e $(tail -n 1 .tempgabarito)
echo -e "Gabarito:\n$(tail -n 1 .tempgabarito)" >> .completeout

# extrai o local dos gabaritos a partir do local das pastas onde eles est
sed -i "s#^/home[^ ]*#\"find '&' | egrep -i '(.*gab.*|.*def.*)(\.html|\.pdf)' |
sed 's@/home/@file:/home/@g'\"#g" .completeout
  while read line
  do
    if [ ${line:0:1} == \" ]
    then
      line=`echo $line | sed -e s/\"//g`
      eval $line
    else
      echo $line
    fi
   done < ".completeout"

rm .completeout
rm .tempgabarito
rm .tempanswers
