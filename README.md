# provas-uem-regex
Baixa todas as provas dos vestibulares anteriores da Universidade Estadual de Maringá e utiliza expressões regulares para procurar por termos.

## Como usar:
Os scripts devem ser executados em um sistema que executa scripts bash.

Execute o arquivo ``setup.sh`` e siga as instruções para baixar as provas, e então utilize ``uem_regex.sh`` para realizar as buscas.

Obs: as buscas são feitas através de expressões regulares, então ``./uem_regex.sh "ângulo"`` retornará correspondências que contêm "retângulo" ou "triângulo", para evitar isso, envolva a expressão por ``\b``, na forma ``./uem_regex.sh "\bângulo\b"``
